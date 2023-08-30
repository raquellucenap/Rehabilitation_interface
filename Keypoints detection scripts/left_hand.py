from pythonosc import osc_message_builder
from pythonosc import osc_bundle_builder
from pythonosc import udp_client
# Importing Libraries
import cv2
import mediapipe as mp
# Importing Libraries
# to a dictionary.
from google.protobuf.json_format import MessageToDict

#send OSC messages to port 6448 on localhost
client = udp_client.SimpleUDPClient("127.0.0.1", 6448)
print("Sends 20 hand coordinates (40 keypoints X and Y) to Wekinator via OSC")
print("Sends to port 6448 with OSC message name /wek/inputs")
#print("A message is sent for each word you enter below.")

# Initializing the Model
mpHands = mp.solutions.hands
hands = mpHands.Hands(
    static_image_mode=False,
    model_complexity=1,
    min_detection_confidence=0.75,
    min_tracking_confidence=0.75,
    max_num_hands=2)


def sendOsc(multi_hand_landmarks, client):
    msg = osc_message_builder.OscMessageBuilder(address="/wek/inputs")
    for landmark in multi_hand_landmarks:
        for point in landmark.landmark:
            x = point.x
            y = point.y
            z = point.z
            #print(f"Landmark: x={x}, y={y}, z={z}")
            msg.add_arg(x)
            msg.add_arg(y)
    msg = msg.build()
    client.send(msg)


# Start capturing video from webcam
cap = cv2.VideoCapture(0)
first = True
while True:
    # Read video frame by frame
    success, img = cap.read()

    # Flip the image(frame)
    img = cv2.flip(img, 1)

    # Convert BGR image to RGB image
    imgRGB = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)

    # Process the RGB image
    results = hands.process(imgRGB)
        
    # If hands are present in image(frame)
    if results.multi_hand_landmarks:
        # Both Hands are present in image(frame)
        if len(results.multi_handedness) == 1:
            for i in results.multi_handedness:
                # Return whether it is Right or Left Hand
                label = MessageToDict(i)[
                    'classification'][0]['label']
                if label == 'Left':
                    # Display 'Left Hand' on left side of window
                    cv2.putText(img, label+' Hand', (460, 50),
                                cv2.FONT_HERSHEY_COMPLEX,
                                0.9, (0, 255, 0), 2)
                    sendOsc(results.multi_hand_landmarks, client)
    # Display Video and when 'q' is entered, destroy the window
    cv2.imshow('Image',img)
    if cv2.waitKey(1) & 0xff == ord('q'):
        break
