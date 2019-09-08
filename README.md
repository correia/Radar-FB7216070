Based on Apple [sample code](https://developer.apple.com/documentation/uikit/app_and_environment/scenes/supporting_multiple_windows_on_ipad).

### Summary:

Requesting a scene session refresh in certain states can cause scene windows to go blank/black.

### Steps to Reproduce:

Build and run the attached sample code. See the code and detailed comment in SceneDelegate.sceneWillResignActive(_:).

Once the application is running, transition slowly into the application picker, and then wait.

Two seconds after you initiate the transition, the application request a scene refresh to simulate sync data coming in off the network that requires a UI state update.

### Expected Results:

The UI state updates. (In this sample app, there should be no visual change.)

### Actual Results:

The application window goes blank/black and becomes unusable.

### Version/Build:

iOS 13.1 b2

### Configuration:

This problem happens on all device/hardware classes.

