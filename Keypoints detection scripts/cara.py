from pythonosc import osc_message_builder
from pythonosc import udp_client
import cv2
import mediapipe as mp
from google.protobuf.json_format import MessageToDict

# Envia mensajes OSC al puerto 6448 en localhost
client = udp_client.SimpleUDPClient("127.0.0.1", 6448)
print("Envía las coordenadas de la cara (468 puntos X e Y) a Wekinator a través de OSC")
print("Se envía al puerto 6448 con el nombre de mensaje OSC /wek/inputs")

# Inicializa el modelo
mpFace = mp.solutions.face_mesh
face_mesh = mpFace.FaceMesh(
    static_image_mode=False,
    max_num_faces=1,
    min_detection_confidence=0.75,
    min_tracking_confidence=0.75
)

def sendOsc(face_landmarks, client):
    msg = osc_message_builder.OscMessageBuilder(address="/wek/inputs")
    for landmark in face_landmarks:
        x = landmark.x
        y = landmark.y
        z = landmark.z
        msg.add_arg(x)
        msg.add_arg(y)
    msg = msg.build()
    client.send(msg)

# Inicia la captura de video desde la webcam
cap = cv2.VideoCapture(0)
while True:
    # Lee el frame del video
    success, img = cap.read()

    # Convierte la imagen BGR a RGB
    imgRGB = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)

    # Procesa la imagen RGB
    results = face_mesh.process(imgRGB)

    # Si se detecta una cara en la imagen
    if results.multi_face_landmarks:
        # Solo se procesa la primera cara detectada
        face_landmarks = results.multi_face_landmarks[0].landmark
        sendOsc(face_landmarks, client)

    # Muestra el video y si se presiona 'q', cierra la ventana
    # Flip the image(frame)
    cv2.imshow('Image', cv2.flip(img, 1))
    if cv2.waitKey(1) & 0xff == ord('q'):
        break

cap.release()
cv2.destroyAllWindows()
