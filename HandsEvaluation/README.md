The files in the folder allow the evaluation of different machine learning algorithms applied in the classification of hands gestures.

The notebook has different sections:
1. Import the Python libraries
2. Create the directories to the folders (modify if using the repository)
3. Define the Python interface, for this two windows are created that use the 'PySimpleGUI' library. The interface allows: defining the number of classes to train and the number of images that define each class, extracting the keypoints using MediaPipe and applying a classification algorithm.
4. Subsequently, an interface is also created to create test images to test the classifier trained in the previous point on new data.
5. The precision of the algorithms is calculated for 5 different algorithms: SVM, KNN, DT, AB and NB.
6. To use the notebook, the folders data, dataOutputMovenet, resized and test should exist on the same directory.
