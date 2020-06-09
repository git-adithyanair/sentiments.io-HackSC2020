# sentiments.io (QWER-Hacks 2020)

## Description

In this day and age, mental health has rendered itself as one of the most consequential  issues society faces. While some simply don't have access to mental healthcare, those who do are still discouraged from seeking the same due to stigma still attached to mental health issues. *sentiments.io* works to make mental healthcare more accessible to a larger number of people by letting them track their thoughts and ideas as notes on the app (or by taking a picture of a diary entry, for instance), after which the app uses a custome made NLP model to assign a "happiness" score to each entry which can be viewed in graph form. Moreover, the app supports a "therapist" mode in which a therapist can login and view their patient's happiness scores after the patient provides their username to their therapist.

While *sentiments.io* is targeted for mental health patients, anyone who wants to keep track of how positive or negative their thoughts are improve their mental well-being.

Check out our DevPost writeup for more information:
https://devpost.com/software/sentiments-io

## Setup

### Installation of Cocoapods

Install Cocoapods onto your macOS device by opening the shell window and running the command:

```bash
sudo gem install cocoapods
```

Only do this if you haven't installed Cocoapods before.

### Downloading the required pods

1. Download the project files.

2. Open the shell window and navigate to the HackSC directory.

3. Run ``` pod install ```.

4. Open the new .xcworkspace file created and run the app.

## How it works

The app allows secure login and authentication for both users and therapists using Google Cloud's Firebase Authentication service. For the therapist, after a successful login they are simply prompted to enter in their patient's username to access only a graph of their feelings. After the user logins, they can either view all their previous notes or can either add a new one. The user's notes are stored securely in the cloud using Google Cloud's Firestore service. The user can either enter in their thoughts by typing them on out or by taking a picture of handwritten notes. Google Cloud's Vision API is used to convert the words in the image into text in digital form. The user can finally view a graph (the same one shown to the therapist) consisting of a measure of how positive or negative each of their entries are. An NLP model is used to determine this, and was created using Apple's CreateML application and trained using a data set consisting of a variety of tweets, each either classified as happy or sad. 

## Team members

* *Adithya Nair (GitHub: **@git-adithyanair**)*
* *Aritra Mullick (GitHub: **@aritramullick**)*
* *Abhishek Marda (GitHub: **@AbhishekMarda**)*
