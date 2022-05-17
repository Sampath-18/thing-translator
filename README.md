# thing-translator
This is an android app built using flutter Dart language.
The app requires a photo as an input and predicts the thing present in the provided photo using mobilenet arcihtecture of CNNs. The predicted image and the confidence percentage of the prediction is also printed on the user screen.
The user can also select a language in which user wants to see the prediction which is a good use to travellers(to know the name of a particular thing in various languages).
The heart of the project lies in choosing the model to predict the class of the input image. 
We selected mobilenet architecture for mobiles, trained using ImageNet dataset and tflite(for good computational speed on mobiles).
