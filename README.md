# Rehabilitation_interface
The GitHub repository contains all the code, images, sounds and documents that are part of the Master's thesis degree.

The description of the folder's content is:
### 1. Body Evaluation
It contains a Jupyter Notebook file that allows computing the accuracy metrics on the classification task of body gestures. The notebook explores which algorithm is the best in Python for classification task using different number of classes. The content of the other folders is created when the notebook runs. 

**Data:** contains the images used for train and validation.

**DataOutputMovement:** contains the keypoints of the data used per train and validation. 

**resized:** contains smaller images that are shown on the interface.

**test:** contains the images created for testing the algorithms with data generated on a different environment. 

### 2. Hands Evaluation
It contains a Jupyter Notebook file that allows computing the accuracy metrics on the classification task of hands gestures. The notebook explores which algorithm is the best in Python for classification task using different number of classes. The content of the other folders is created when the notebook runs. 

**Data:** contains the images used for train and validation.

**DataOutputMovement:** contains the keypoints of the data used per train and validation. 

**resized:** contains smaller images that are shown on the interface.

**test:** contains the images created for testing the algorithms with data generated on a different environment. 

Data folder, resized folder an test folder images are not included on Body and Hands evaluation as these are private images. The images are uploaded on the following Drive link, https://drive.google.com/drive/folders/1o3mngJps7lQou2gLtHKfzTmubZII9v1i?usp=sharing . If you want to have access to the images click request access to view the images. However, you can create your own dataset with the Jupyter Notebook, with the correct folders and paths. 


### 3. Keypoints detection scripts
Each patient has to rehabilitate a different body area. On this folder there are the python scripts that corresponds to each one of the area. 

**.py files** uses deep learning pretrained models (MediaPipe or Movenet) to extract the body points and send the points through an OSC port to Wekinator.

**.spec files** provides the necessary information to automatically convert the script file (.py) to an executable file (.exe)

Here are the lines that defines the .spec and how to convert them to executables using the Windows terminal. It is necessary to create the executable files to automatically run the body key detections code when the user clicks on the body area to be rehabilitated on the Processing interface. 


```pip install pyinstaller```

*Movenet*

``` #open de correct directory ```

 ```pyinstaller --onefile body.py ```

*MediaPipe*

```pyi-makespec --onefile cara.py```

```pyinstaller cara.spec```

The Analysis name of the .spec file and the datas field are the values that should be change to generate de executables. 

### 4. Processing Interface
The folder has all the Processing code of the digital music interface. There are five folder:

**main interface** is the principal interface, by running the file *main_interface.pde* all the other tasks can be used.

**Game drums, game music, task drums and task music** are each one of the newtasks and interfaces that can be selected with the interaction of the main interface. 

All the folders contains all the necessary images, sounds and code to have the complete interface working. 

### 5. Python Interface
The folder contains the first proposed interface, it is not as developed as the processing interface, but it can be used to do rehabilitation on real - time (with some delay). 

### 6. Results data and script
Here is the data coming from the questionnaires.  The notebook uses the data from *users.csv* and *music.csv* to study the use of a digital music interface as a rehabilitation system and compare it to a traditional music instrument.

### 7. Wekinator
Only contains an example of Wekinator project; however, to use it later, the data should be recorded again. 

### 8. Variables
This folder is necessary to work with TensorFlow on my computing.

### More files
**Thesis paper:** is the final master thesis paper *Digital music interfaces for motor rehabilitation: a motion capture and machine learning approach* developed on the Music Technology Group at UPF. 

**Thesis presentation:** is the final master thesis presentation *Digital music interfaces for motor rehabilitation: a motion capture and machine learning approach* developed on the Music Technology Group at UPF. 

**Saved model:** is the Movenet model running on Body keypoints detection. It has been downloaded from https://www.tensorflow.org/hub/tutorials/movenet . 
