import warnings
# Import TF and TF Hub libraries.
import tensorflow as tf
import tensorflow_hub as hub
#GUI
import PySimpleGUI as sg
import os, csv, tqdm, cv2, time
from PIL import Image
import numpy as np
import pandas as pd
import shutil
# Import Classifiers
from sklearn.model_selection import train_test_split as tts
from sklearn import svm
from sklearn import metrics
from sklearn.neighbors import KNeighborsClassifier

# from sklearn.externals import joblib
import joblib
import threading
#import pygame
import playsound
from playsound import playsound
import socket

from pythonosc import osc_message_builder
from pythonosc import osc_bundle_builder
from pythonosc import udp_client
warnings.filterwarnings("ignore")


directory = "/Users/raquel/Documents/GitHub/"
#Path to the folder containing the input images
images_folder = directory +'Rehabilitation_interface_doc/BodyEvaluation/Data/' #1
images_out_folder = directory +'Rehabilitation_interface_doc/BodyEvaluation/DataOutputMovenet/' #2
## Obtener rutas de las imágenes
resized_path = directory +'Rehabilitation_interface_doc/BodyEvaluation/resized/' #3
# Path to the output CSV file
csv_out_path = directory +'Rehabilitation_interface_doc/BodyEvaluation/DataOutputMovenet/fitness_poses_csvs_out_basic_movenet.csv' #4
# Download the model from TF Hub.
model_path = directory +'Rehabilitation_interface_doc' #5
#Initializing the model
model = tf.saved_model.load(model_path)
movenet = model.signatures['serving_default']
path_to_data = directory +'Rehabilitation_interface_doc/BodyEvaluation/Data'
path_to_classes = directory +'Rehabilitation_interface_doc/BodyEvaluation/Data/clase'

#Layout definition
def create_classes_layout():
    ## Define the layout for the "Create Classes" window
    layout = [
        [sg.Text('Number of classes:'), sg.InputText(default_text='2',size=(10,1))],
        [sg.Text('Number of photos per class:'), sg.InputText(default_text='5',size=(10,1))],
        [sg.Button('Create Classes')],
        [sg.Text(size=(40,1), key='-OUTPUT-')],
        [sg.Image(filename='', key='-IMAGE-', size=(30,15))],
        [sg.Button('Close window')],
    ]
    return layout

client = udp_client.SimpleUDPClient("127.0.0.1", 12001)

def sendOsc(message, client):
    msg = osc_message_builder.OscMessageBuilder(address = "/adress")
    msg.add_arg(message)
    msg = msg.build()
    client.send(msg)

#Creation of windows
def create_classes_window():
    ## Create the "Create Classes" window
    layout = create_classes_layout()
    window = sg.Window('Pose Classifier - Create Classes', layout)
    return window

#Creation of the classes with the interface
def create_classes(window, path_to_data, path_to_classes, num_classes, num_photos, time_between_photos):
    # Remove all directories that start with "clase"
    for root, dirs, files in os.walk(path_to_data):
        for dir in dirs:
            if dir.startswith("clase"):
                shutil.rmtree(os.path.join(root, dir))
    for clase in range(num_classes):
        # Wait for the user to be ready
        sg.popup('Haz la posición número {}. Pulsa OK cuando estés listo.'.format(clase+1), title='¡Listo!')
        window['-OUTPUT-'].update('Haz la posición número {}. Esperando...'.format(clase+1))
        window.refresh()
        time.sleep(3)
        folder_name = str(path_to_classes+str(clase))
        if not os.path.exists(folder_name):
            os.makedirs(folder_name)
        # Loop to take the photos
        for i in range(num_photos):
            window['-OUTPUT-'].update('Foto {} de {}'.format(i+1,num_photos))
            window.refresh()
            # Read a frame from the webcam
            ret, frame = camera.read()
            # Convert the image to PNG Bytes
            resized = cv2.resize(frame, (0, 0), fx=0.25, fy=0.25)
            imgbytes = cv2.imencode('.png', resized)[1].tobytes()
            # Check if the camera is working
            if not ret:
                window['-OUTPUT-'].update('La cámara no funciona!')
                window.refresh()
                break
            # Update the image element in the GUI with the new image
            window['-IMAGE-'].update(data=imgbytes)
            # Generate the file name for the current picture
            filename = folder_name+'/photo_{}.png'.format(i)
            # Save the frame to a file
            cv2.imwrite(filename, frame)
            # Wait for the specified time before taking the next photo
            time.sleep(time_between_photos)

# Change size images to see them on the interface
def class_image_resized():
    image_paths = []

    for folder_name in os.listdir(images_folder):
        if folder_name.startswith("clase"):
            image_paths.append(os.path.join(images_folder, folder_name, "photo_0.png"))
    for i, image_path in enumerate(image_paths):
        img = Image.open(image_path)
        img_resized = img.resize((100, 100))
        resized_image_path = os.path.join(resized_path, f"clase{i}.png")
        img_resized.save(resized_image_path)
    
    image_columns = []
    for i in range(len(image_paths)):
        image_column = sg.Column([[sg.Image(filename = os.path.join(resized_path,f"clase{i}.png"))]])#, pad = (0,0))
        image_columns.append(image_column)
    return image_columns

#Buttons to train and classify the models
def create_training_layout():
    image_columns = class_image_resized()
    # Creamos un layout con una fila y las columnas de las imágenes
    layout = [image_columns]
    # Add remaining GUI elements
    layout += [
        [sg.Text('The rehabiliation is fixed on Full body')],
        #[sg.Checkbox('Full body:', default=True, key="-Full body-"),sg.Checkbox('Cara:', default=False, key="-Cara-"),sg.Checkbox('Torso:', default=False, key="-Torso-"),sg.Checkbox('Piernas:', default=False, key="-Piernas-"),sg.Checkbox('Puntos fiables:', default=False, key="-Puntos fiables-")],
        [sg.Button('Train Model')],
        [sg.Text(size=(50,1), key='-1-')],
        [sg.Button('Classify Pose from Camera')],
        [sg.Text(size=(50,1), key='-2-')],
        [sg.Button('Try Real Time'), sg.Button('STOP', button_color=('white', 'red'))],
        [sg.Text(size=(50,1), key='-3-')],
        [sg.Button('Close Window')]
    ]
    return layout
#Corret format of the indexes
def keypoints_format(list_points):
    #list_points = [list_points[i]-1 for i in range(len(list_points))]
    idx = pd.Index(list(map(str, list_points)))
    return idx
def keypoints_in_range(list_points):
    new_idx = [int(list_points[i])-1 for i in range(len(list_points))]
    updated_idx = pd.Index(new_idx)
    return updated_idx
#Choose keypoints to detect
def keypoints_per_part_of_body(values):
    df = pd.read_csv(csv_out_path)    
    list_points = [1, 2, 3, 4, 5, 6,7,8,9,10,11,12,13,14,15,16,17]
    idx = keypoints_format(list_points)    
    numbers = df.columns.str.extract(r'(x|y)(\d+)')[1] #obtenemos los valores numericos de las columnas
    cols_to_keep = df[df.columns[df.columns.isin(['name', 'class']) | numbers.isin(idx)]]
    cols_to_keep.to_csv(csv_out_path, index=False) #guardamos el dataframe final en el fichero csv_out_path sobrescribiéndolo
    df = pd.read_csv(csv_out_path)
    #display(df)
    idx = keypoints_in_range(idx)
    return idx

#Second windows
def create_training_window():
    ## Create the "Create Classes" window
    layout = create_training_layout()
    window = sg.Window('Ejemplo de imágenes', layout)
    return window

# Define the function to extract landmarks from an image
def extract_landmarks(image_path):
    #Load images
    image = tf.io.read_file(image_path)
    image = tf.compat.v1.image.decode_jpeg(image)
    image = tf.expand_dims(image, axis=0)
    # Resize and pad the image to keep the aspect ratio and fit the expected size.
    image = tf.cast(tf.image.resize_with_pad(image, 192, 192), dtype=tf.int32)

    # Run model inference.
    outputs = movenet(image)
    # Output is a [1, 1, 17, 3] tensor.
    #keypoints = outputs['output_0'] # 17 keypoints
    #only 10 points
    #keypoints = outputs['output_0'][:, :, :10, :]  # Only take the first 10 keypoints
    keypoints = outputs['output_0']

    return keypoints

# Extract features from images
def extract_features_to_train(csv_out_file, images_folder, images_out_foulder):
    csv_out_writer = csv.writer(csv_out_file, delimiter=',', quoting=csv.QUOTE_MINIMAL)
    # Folder names are used as pose class names.
    pose_class_names = sorted([n for n in os.listdir(images_folder) if not n.startswith('.')])
    # Write the header row to the CSV file
    csv_out_writer.writerow(['name', 'class', 'x1', 'y1', 'p1', 'x2', 'y2', 'p2', 'x3', 'y3', 'p3', 'x4', 'y4', 'p4', 'x5', 'y5', 'p5', 'x6', 'y6', 'p6', 'x7', 'y7', 'p7', 'x8', 'y8', 'p8', 'x9', 'y9', 'p9', 'x10', 'y10', 'p10', 'x11', 'y11', 'p11', 'x12', 'y12', 'p12', 'x13', 'y13', 'p13', 'x14', 'y14', 'p14', 'x15', 'y15', 'p15', 'x16', 'y16', 'p16', 'x17', 'y17', 'p17'])  # Header row
    for pose_class_name in pose_class_names:
        message = f'Bootstrapping {pose_class_name}'
        window['-1-'].update(message)
        if not os.path.exists(os.path.join(images_out_folder, pose_class_name)):
            os.makedirs(os.path.join(images_out_folder, pose_class_name))
        image_names = sorted([
        n for n in os.listdir(os.path.join(images_folder, pose_class_name))
        if not n.startswith('.')])
        new_row = []
        for image_name in tqdm.tqdm(image_names, position=0):
            new_row = []
            # Extract the landmarks from the image
            landmarks = extract_landmarks(os.path.join(images_folder,pose_class_name, image_name))
            # Assuming you have the pose data in a variable named `pose`
            pose_np = np.squeeze(landmarks.numpy())  # Remove the batch and channel dimensions
            pose_np = pose_np.transpose()
            # Write pose sample to CSV.
            new_row.append(image_name)
            new_row.append(pose_class_name)
            for i in range(pose_np.shape[1]):
                x = pose_np[0,i]
                y = pose_np[1,i]
                p = pose_np[2,i]
                new_row.append(x)
                new_row.append(y)
                new_row.append(p)
            # Save the landmarks to the CSV file
            csv_out_writer.writerow(new_row)
    # Aqui quiero cambiar todo el fichero csv_out_path y sobreescribirlo
    csv_out_file.close()
    #return idx
    idx = keypoints_per_part_of_body(values)
    return idx

#Classify the images
def classify_from_data():
    df = pd.read_csv(csv_out_path)
    y = df["class"]
    x = df.loc[:,df.columns!="class"]
    x = x.loc[:,x.columns!="name"]
    ###Splitting train/test data
    #display(x)
    X_tr, X_tst, y_tr, y_tst = tts(x, y, test_size=25/100,random_state=109)
    ###Creating Support Vector Machine Model
    # Crear un modelo KNN con, por ejemplo, 3 vecinos (puedes ajustar este valor)
    clf = KNeighborsClassifier(n_neighbors=3)
    # Entrenar el modelo KNN con los datos de entrenamiento
    clf.fit(X_tr, y_tr)

    #model_params = clf.
    #pd.DataFrame(model_params).to_csv('modelo_knn.csv', index=False)
    ###Making Predictions
    y_pr = clf.predict(X_tst)
    return clf, y_tst, y_pr


# Create a socket connection to the Processing sketch
HOST = '127.0.0.1'  # IP address of the Processing sketch
PORT = 12345  # Port on which the Processing sketch is listening

def send_class_to_processing(class_name):
    print(class_name)
    try:
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
            print('1')
            s.connect((HOST, PORT))
            print('2')
            s.sendall(class_name.encode())
            print('3')
            print('sent', class_name)
    except Exception as e:
        print("Error sending data to Processing:", e)


#Try the interface in real time
def loop(clf, idx):            
    global stop_flag
    # Initialize the webcam
    camera = cv2.VideoCapture(0)
    flag0 = 0
    flag1 = 0
    # Check if the webcam is opened correctly
    if not camera.isOpened():
        print("Cannot open camera")
        window['-3-'].update("Cannot open camera")
        exit()
    else:
        print("Camera opened.")
        window['-3-'].update("Camera opened.")
    stopped = False
    while not stopped:
        event, values = window.read(timeout=0)  # Add timeout=0 to avoid GUI freezing
        if event == 'STOP':
            stop_flag = True
            window['-3-'].update("Loop stopped.")
        pose_landmarks_csv = []
        pose_landmarks_img = []
        # Read a frame from the webcam
        ret, image = camera.read()
        if image is not None:
            success, encoded_image = cv2.imencode('.png', image)
            if success:
                image = tf.io.decode_image(encoded_image.tobytes(), channels=3, expand_animations=False)
                image = tf.expand_dims(image, axis=0)
                # Resize and pad the image to keep the aspect ratio and fit the expected size.
                image = tf.cast(tf.image.resize_with_pad(image, 192, 192), dtype=tf.int32)
                # Run model inference.
                outputs = movenet(image)
                idx_tensor = tf.constant(idx, dtype=tf.int32)
                keypoints = tf.gather(outputs['output_0'], idx_tensor, axis=2)
                #break       
                if keypoints is not None:
                    pose_np = np.squeeze(keypoints.numpy())  # Remove the batch and channel dimensions
                    pose_np = pose_np.transpose()
                    for i in range(pose_np.shape[1]):
                        pose_landmarks_csv.append(pose_np[0, i])
                        pose_landmarks_csv.append(pose_np[1, i])
                    for i in range(pose_np.shape[0]):
                        pose_landmarks_img.append((int(pose_np[i][0]), int(pose_np[i][1])))
                # Classify pose
                y_pr = clf.predict(pd.DataFrame(pose_landmarks_csv).transpose())
                i = y_pr[0]
                if i == 'clase0' and flag0 == 0:
                    start = time.time()
                    path_audio1 = '/Users/raquel/Documents/GitHub/Rehabilitation_interface/BodyEvaluation/DataOutputMovenet/drums/drum3.wav'
                    # playsound(path_audio1)
                    window['-3-'].update("Clase 0.")
                    flag0 = 1
                    flag1 = 0
                    # Send the detected class to Processing
                    sendOsc('clase0', client)
                elif i == 'clase1' and flag1 == 0:
                    start = time.time()
                    path_audio6 = '/Users/raquel/Documents/GitHub/Rehabilitation_interface/BodyEvaluation/DataOutputMovenet/drums/drum6.wav'
                    # playsound(path_audio6)
                    print(time.time() - start)
                    window['-3-'].update("Clase 1.")
                    flag1 = 1
                    flag0 = 0
                    # Send the detected class to Processing
                    sendOsc('clase1', client)
                #print("Error al codificar la imagen.")
        else:
            print("X")
        if stop_flag:
            stopped = True
    camera.release()
    window['-3-'].update("Loop stopped.")        


# Event loop to process GUI events
window = create_classes_window()
while True:
    event, values = window.read()
    if event == sg.WIN_CLOSED:
        break
    if event == 'Create Classes':
        window['-OUTPUT-'].update('Creating classes...')
        window.refresh()
        # Initialize the webcam
        camera = cv2.VideoCapture(0)
        # Close if we try to crate new data without specifying the size
        try:
            num_classes = int(values[0])
            num_photos = int(values[1])
        except ValueError:
            window.close()
            break
        # Define the number of photos to take and the time between photos
        num_classes = int(values[0])
        num_photos = int(values[1])
        time_between_photos = 0.5
        create_classes(window, path_to_data, path_to_classes, num_classes, num_photos, time_between_photos)       
        # Release the webcam
        camera.release()
        window['-OUTPUT-'].update('Classes created')
        time.sleep(2)
        window.close()
    elif event == 'Close window':
        break        
# Close the window when the event loop is exited
window.close()
#SEGUNDA VENTANA
# Crear la ventana y mostrarla
window = create_training_window()
stop_flag = True
while True:
    event, values = window.read()
    if event == sg.WINDOW_CLOSED:
        break
    elif event == 'Train Model':
        with open(csv_out_path, 'w') as csv_out_file:
            idx = extract_features_to_train(csv_out_file, images_folder, images_out_folder)
            #print('idx', idx)
            window['-1-'].update('Model trained')
    elif event == 'Classify Pose from Camera':
        ###Evaluating Prediction Accuracy
        clf, y_tst, y_pr = classify_from_data()
        window['-2-'].update(f'Pose classified from camera. Accuracy: {metrics.accuracy_score(y_tst, y_pr)}')
        print('Pose classified from camera. Accuracy:', metrics.accuracy_score(y_tst, y_pr))
    elif event == 'Try Real Time':
        stop_flag = False
        window['-3-'].update("Loop running...")
        loop(clf, idx)
    elif event == 'Close Window':
        stop_flag = True
        window.Close()
window.Close()