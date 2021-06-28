# TV Shows Challenge

## Goal

The goal of this project was to create an app that access an API and show information about TV series. The app contains the following:

+ PIN screen;
  - Register PIN screen;
+ List of TV Shows;
  - Detailed information about a TV Shows;
- Search for a TV Show;
+ Search for a person connected to a TV Show
  - Details about said person;
- List of Favorit TV Shows (TV Shows can be marked as favorite on it's detailed information screen);
- Options screen, where the user can select if it will use the device's biometry authentication (if possible);

## Project minimum requirements:

- Xcode 9.3 +
- MacOS Sierra 10.15 +
- iOS 11 +
- Swift 4 +

## Project Dependencies:

This project runs using 3rd party code libraries managed by Cocoapods, to install
it you must:

- **sudo gem install Cocoapods**

in the root folder of the project:

- **pod install**

Installed Pods:

- **SwiftSpinner**: responsible to open a loader screen;
- **IQKeyboardManagerSwift**: responsible to manage the keyboard over the app;
- **ImageViewer**: used to open images fullscreen;

Run the new **Challenge.xcworkspace** file.

## About the Project

All API calls are handled on the Services.swift file, which contains a completion handler for each call that always returns a success or a failure, as well as the object or list of objects as needed. All JSON responses are managed using the Decodable protcol.

The design of the application were all handled on the Storyboards using AutoLayout, and the navigation is made through segues. There are a few NIB files for specific cells (TableView or CollectionView). 

For each ViewController there is a ViewModel that controls the data and methods related to it, leaving the ViewController to handle only what is supposed to be presented to the user.

To store the information about the user's Favorte Shows it was used **CoreData**.

The PIN registered to log into the app is stored over the device's **KeyChain**.

## Unit Tests

You can run a fwe Unit Test cases over the TestChallenge target.
