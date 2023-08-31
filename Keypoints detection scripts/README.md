This folder contain the Python scripts that detects points on different body parts:
1. Hands
2. Left hand
3. Right hand
4. Full body
5. Torso and arms
6. Full body (without face)
7. Face
   
The Python scripts follow the same structure:
1. Import the Python libraries
2. Set the port OSC where messages are sent
3. Initialize the landmark detection models.
4. Define the function that sends data and wrote the message.
5. Open the camera, capture a new image, process it and extract the landmarks. 
6. Send the landmarks to Wekinator.

The Spec files have the instrucctions, when the following command ```pyinstaller cara.spec``` is runned the executables are created. 
