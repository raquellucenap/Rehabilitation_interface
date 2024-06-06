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
import webbrowser
# Import Classifiers
from sklearn.model_selection import train_test_split as tts
from sklearn import svm
from sklearn import metrics
import threading
#import pygame
import playsound
from playsound import playsound

warnings.filterwarnings("ignore")

body_parts_mapping = {
    "Nose": 1, "Left Eye": 2, "Right Eye": 3, "Left Ear": 4, "Right Ear": 5,
    "Left Shoulder": 6, "Right Shoulder": 7, "Left Elbow": 8, "Right Elbow": 9, 
    "Left Wrist": 10, "Right Wrist": 11, "Left Hip": 12, "Right Hip": 13,
    "Left Knee": 14, "Right Knee": 15, "Left Ankle": 16, "Right Ankle": 17
}

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
    layout = [
        # [sg.Image(filename='/Users/raquel/Documents/imagenes/IMG_7571.PNG', key='-BACKGROUND-')],
        [sg.Text('Number of classes:', font=('Helvetica', 18)), sg.InputText(default_text='2', size=(5, 2), font=('Helvetica', 18))],
        [sg.Text('Number of photos per class:', font=('Helvetica', 18)), sg.InputText(default_text='5', size=(5, 2), font=('Helvetica', 18))],
        [sg.Button('Create Classes', size=(15, 1), font=('Helvetica', 18))],
        [sg.Text(size=(40, 1), key='-OUTPUT-', font=('Helvetica', 18))],
        [sg.Image(filename='', key='-IMAGE-', size=(30, 15))],
        [sg.Button('Close window', size=(15, 1), font=('Helvetica', 18))],
    ]
    return layout

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
        sg.popup('Haz la posición número {}. Pulsa OK cuando estés listo.'.format(clase+1), title='¡Listo!', font=('Helvetica', 18))
        window['-OUTPUT-'].update('Haz la posición número {}. Esperando...'.format(clase+1), font=('Helvetica', 18))
        window.refresh()
        time.sleep(3)
        folder_name = str(path_to_classes+str(clase))
        if not os.path.exists(folder_name):
            os.makedirs(folder_name)
        # Loop to take the photos
        for i in range(num_photos):
            window['-OUTPUT-'].update('Foto {} de {}'.format(i+1,num_photos), font=('Helvetica', 18))
            window.refresh()
            # Read a frame from the webcam
            ret, frame = camera.read()
            # Convert the image to PNG Bytes
            resized = cv2.resize(frame, (0, 0), fx=0.25, fy=0.25)
            imgbytes = cv2.imencode('.png', resized)[1].tobytes()
            # Check if the camera is working
            if not ret:
                window['-OUTPUT-'].update('La cámara no funciona!', font=('Helvetica', 18))
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
        img_resized = img.resize((200, 150))
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
        [sg.Text('The rehabiliation is fixed on Full body', font=('Helvetica', 18))],
        [sg.Checkbox('Full body:', default=True, key="-Full body-", font = ('Helvetica', 18)),sg.Checkbox('Cara:', default=False, key="-Cara-", font = ('Helvetica', 18)),sg.Checkbox('Torso:', default=False, key="-Torso-", font = ('Helvetica', 18)),sg.Checkbox('Piernas:', default=False, key="-Piernas-", font = ('Helvetica', 18)),sg.Checkbox('Puntos fiables:', default=False, key="-Puntos fiables-", font = ('Helvetica', 18))],    
        [sg.Button('Train Model', font=('Helvetica', 18))],
        [sg.Text(size=(50,1), key='-1-')],
        [sg.Button('Classify Pose from Camera', font=('Helvetica', 18))],
        [sg.Text(size=(50,1), key='-2-')],
        [sg.Button('Youtube', font=('Helvetica', 18), button_color=('white', 'maroon'))],
        [sg.Text(size=(50,1))],
        [sg.Button('Try Real Time', font=('Helvetica', 18)), sg.Button('STOP', font = ('Helvetica', 18), button_color=('white', 'red'))],
        [sg.Text(size=(50,1), key='-3-')],
        [sg.Button('Close Window', font=('Helvetica', 18))]
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
    #selected_keypoints = []
    if values["-Full body-"] == True:
        list_points = [1, 2, 3, 4, 5, 6,7,8,9,10,11,12,13,14,15,16,17]
        idx = keypoints_format(list_points)
    elif values["-Cara-"] == True:
        # list_points = [1, 2, 3, 4, 5]
        list_names = ["Nose", "Left Eye", "Right Eye", "Left Ear", "Right Ear"]
        list_points = [body_parts_mapping[part] for part in list_names]
        idx = keypoints_format(list_points)
    elif values["-Torso-"] == True:
        # list_points = [6,7,8,9,10,11,12,13]
        list_names = ["Left Shoulder", "Right Shoulder", "Left Elbow", "Right Elbow",
                       "Left Wrist", "Right Wrist", "Left Hip", "Right Hip"]
        list_points = [body_parts_mapping[part] for part in list_names]
        idx = keypoints_format(list_points)
    elif values["-Piernas-"] == True:
        # list_points = [14,15,16,17]
        list_names = ["Left Knee", "Right Knee", "Left Ankle", "Right Ankle"]
        list_points = [body_parts_mapping[part] for part in list_names]
        idx = keypoints_format(list_points)
    elif values["-Puntos fiables-"] == True:
        columns_p = df.filter(regex='^p') #cogemos las columnas de probabilidades
        df_filtered=df.loc[:,columns_p.columns[df.loc[:, columns_p.columns].gt(0.5).any(axis=0)]] #nos quedamos las columnas donde algun valor p > 0.5
        df_filtered.columns = df_filtered.columns.str.replace('p', '') #nos quedamos solo con los numeros de las columnas de probabilidad
        idx = df_filtered.columns #obtenemos los nombres de las columnas
        new_idx = [str(int(idx[i])) for i in range(len(idx))]
        # Crear un nuevo objeto Index con los valores actualizados
        idx = pd.Index(new_idx)
    #list_points = [1, 2, 3, 4, 5, 6,7,8,9,10,11,12,13,14,15,16,17]
    #idx = keypoints_format(list_points)    
    #idx = keypoints_format(selected_keypoints)
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
        window['-1-'].update(message, font=('Helvetica', 18))
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
    clf = svm.SVC(kernel='rbf')
    ###Training the Model
    clf.fit(X_tr, y_tr)
    ###Making Predictions
    y_pr = clf.predict(X_tst)
    return clf, y_tst, y_pr


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
        window['-3-'].update("Cannot open camera", font=('Helvetica', 18))
        exit()
    else:
        print("Camera opened.")
        window['-3-'].update("Camera opened.", font=('Helvetica', 18))
    stopped = False
    while not stopped:
        event, values = window.read(timeout=0)  # Add timeout=0 to avoid GUI freezing
        if event == 'STOP':
            stop_flag = True
            window['-3-'].update("Loop stopped.", font=('Helvetica', 18))
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
                # Convierte la tupla en un array de NumPy
                keypoints_array = np.array(keypoints)
                # Obtén los índices de las dimensiones que cumplen con la condición
                threshold_confidence = 0.9
                print(keypoints_array[:, :, :, -1], 'confidence')
                indices_to_keep = np.where(keypoints_array[:, :, :, -1] > threshold_confidence)
                # Filtra el array original con base en los índices obtenidos
                filtered_keypoints_array = keypoints_array[indices_to_keep]
                filtered_keypoints = tf.convert_to_tensor(filtered_keypoints_array)
                #keypoints = outputs['output_0'][:, :, :10, :]  # Only take the first 10 keypoints
                       
                if keypoints is not None:
                    #pose_np = np.squeeze(keypoints.numpy())  # Remove the batch and channel dimensions ANTES
                    pose_np = np.squeeze(filtered_keypoints.numpy())  # Remove the batch and channel dimensions
                    pose_np = pose_np.transpose()
                    for i in range(pose_np.shape[1]):
                        pose_landmarks_csv.append(pose_np[0, i])
                        pose_landmarks_csv.append(pose_np[1, i])
                    for i in range(pose_np.shape[0]):
                        pose_landmarks_img.append((int(pose_np[i][0]), int(pose_np[i][1])))
                else:
                    print("No se detectaron puntos clave con confianza suficiente.")
                # Classify pose
                if (clf.n_features_in_ == len(pose_landmarks_csv)):
                    y_pr = clf.predict(pd.DataFrame(pose_landmarks_csv).transpose())
                    i = y_pr[0]
                    if i == 'clase0' and flag0 == 0:
                        start = time.time()
                        path_audio1 = '/Users/raquel/Documents/GitHub/Rehabilitation_interface/BodyEvaluation/DataOutputMovenet/drums/drum3.wav'
                        playsound(path_audio1)
                        window['-3-'].update("Clase 0.", font=('Helvetica', 18))
                        flag0 = 1
                        flag1 = 0
                    elif i == 'clase1' and flag1 == 0:
                        start = time.time()
                        path_audio6 = '/Users/raquel/Documents/GitHub/Rehabilitation_interface/BodyEvaluation/DataOutputMovenet/drums/drum6.wav'
                        playsound(path_audio6)
                        window['-3-'].update("Clase 1.", font=('Helvetica', 18))
                        flag1 = 1
                        flag0 = 0
                    #print("Error al codificar la imagen.")
        else:
            print("X")
        if stop_flag:
            stopped = True
    camera.release()
    window['-3-'].update("Loop stopped.", font=('Helvetica', 18))        


# Event loop to process GUI events
window = create_classes_window()
while True:
    event, values = window.read()
    if event == sg.WIN_CLOSED:
        break
    if event == 'Create Classes':
        window['-OUTPUT-'].update('Creating classes...', font=('Helvetica', 18))
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
        time_between_photos = 0.2
        create_classes(window, path_to_data, path_to_classes, num_classes, num_photos, time_between_photos)       
        # Release the webcam
        camera.release()
        window['-OUTPUT-'].update('Classes created', font=('Helvetica', 18))
        time.sleep(1)
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
            window['-1-'].update('Model trained', font=('Helvetica', 18))
    elif event == 'Classify Pose from Camera':
        ###Evaluating Prediction Accuracy
        clf, y_tst, y_pr = classify_from_data()
        window['-2-'].update((f'Pose classified from camera. Accuracy: {metrics.accuracy_score(y_tst, y_pr)}'), font=('Helvetica', 18))
        #print('Pose classified from camera. Accuracy:', metrics.accuracy_score(y_tst, y_pr))
    elif event == 'Youtube':
        webbrowser.open('https://youtube.com')
    elif event == 'Try Real Time':
        stop_flag = False
        window['-3-'].update("Loop running...", font=('Helvetica', 18))
        loop(clf, idx)
    elif event == 'Close Window':
        stop_flag = True
        window.Close()
window.Close()