import cv2, os, csv, time, sys, tqdm
import numpy as np
import pandas as pd
# Import TF and TF Hub libraries.
import tensorflow as tf
import tensorflow_hub as hub
# # Import Classifiers
# from sklearn import datasets
# from sklearn.model_selection import train_test_split as tts
# from sklearn import svm
# from sklearn import metrics
# #Warnings
#import warnings
# from sklearn.exceptions import ConvergenceWarning
# warnings.filterwarnings('ignore', category=ConvergenceWarning)
# #display and time
# import time
# from IPython.display import display, clear_output
# import ipywidgets as widgets
# from ipywidgets import Video
# from IPython.display import Audio, display
# #GUI
# import PySimpleGUI as sg
# from PIL import Image
# import shutil

#warnings.filterwarnings("ignore")

# Download the model from TF Hub.
model_path = "C:\\Users\\rache\\Documents\\MusicTFM" #5
model = tf.saved_model.load(model_path)
movenet = model.signatures['serving_default']

from pythonosc import osc_message_builder
from pythonosc import osc_bundle_builder
from pythonosc import udp_client

#send OSC messages to port 6448 on localhost
client = udp_client.SimpleUDPClient("127.0.0.1", 6448)

def sendOsc(keypoints, client):
    msg = osc_message_builder.OscMessageBuilder(address="/wek/inputs")
    pose_np = np.squeeze(keypoints.numpy())  # Remove the batch and channel dimensions
    pose_np = pose_np.transpose()
    for i in range(pose_np.shape[1]):   
        x = float(pose_np[0, i])
        y = float(pose_np[1, i])
        msg.add_arg(x)
        msg.add_arg(y)
    msg = msg.build()
    client.send(msg)

# Start capturing video from webcam
cap = cv2.VideoCapture(0)
first = True
while True:
    # Read video frame by frame
    success, image = cap.read()
    img = image
     # Flip the image(frame)
    img = cv2.flip(img, 1)
    success, encoded_image = cv2.imencode('.jpg', image)
    image = tf.io.decode_image(encoded_image.tobytes(), channels=3, expand_animations=False)
    image = tf.expand_dims(image, axis=0)
    # Resize and pad the image to keep the aspect ratio and fit the expected size.
    image = tf.cast(tf.image.resize_with_pad(image, 192, 192), dtype=tf.int32)
    # Run model inference.
    outputs = movenet(image)
    # Extract keypoints from index 5 to 12
    idx = np.squeeze(range(5, 13))
    idx_tensor = tf.constant(idx, dtype=tf.int32)
    keypoints = tf.gather(outputs['output_0'], idx_tensor, axis=2)
    sendOsc(keypoints, client)
    # keypoints = outputs['output_0']
    # sendOsc(keypoints, client)
    
    cv2.imshow('Image', img)
    # Display Video and when 'q' is entered, destroy the window
    if cv2.waitKey(1) & 0xff == ord('q'):
        break