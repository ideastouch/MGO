App main idea:
Swift basic app with login/signup functionalities and video playback.
The app is designed Universal and supprt Landscape an Portrait orientations.
The app also has in the main screen six icons that change theyr sizes and distributions according to the device and orientation.


Framework
=========
- Propose high level framework for a modular layout with a separation of UI and business logic.
GH: Done

- Describe pros and cons of framework and if it is based on MVVM/MVC/other.
GH: I think that ther best for XCode is MVC: Model - View - Controller
The cons of MVC could be for small projects or simpler screens in which is not needed to write 3  diferents class, on the other hand XCode provide
 View Controllers (for example UIVIewController) that can do everything in one object.
The pros of MVC is the reusabilitiy of the code, also the casses may be smaller and finally is more clear the goals of each class.
Other models as for example MVVM are great for web pages where the model is comming from the server.

Mini-project
============
Build a small app that consists of 4 simple forms:
- Create account ()
GH: Done

- Login screen / Create account
GH: Done

- Use mock data for authentication
GH: Done

- Simple grid view of items (each element is clickable)
GH: Done

- For each element have a details page describing the item
GH: Done

- Video player with simple playback HLS and standard simple MP4 files. Player must include full controls including volume (extra points for CC as well)
GH: Done

Deliverables
============
- Source code + ready to deploy to SDK (iOS 6.0 or higher )
GH: Done, was used Swift (iOS 8 only), the app is universal and support portrait and landscape


Things to consider
==================
- Your build will be loaded by us on to both a phone + tablet and verified.
GH: Done

- We would like to see how a web service is called and the data provided to the view and rendered.
GH: I used AVVideoController.

- Can you explain how a typical Git repository and build scripts would be setup.
GH: A titpica Git repo has a Master branch, versions branch and Tags.
In order to start git repo I always use my GitHub account, create one empty repo almost empty, then I clone it to my computer and start to work. Usually
work in private locals branch and rebase my changes when I finish.

- The application must handle back correctly.
GH: The appication allow go foward and backard.