# Instagram Clone

A Flutter application to display Instagram-like stories with animations, smooth transitions, and progress bars. It supports multiple stories for each account and auto-advances through the stories.

## Features

- Display stories with smooth transitions and animations.
- Show progress bars on top of each story based on its duration.
- Support multiple stories for each account.
- Navigate between stories by tapping on the left or right side of the screen.
- Auto-advance to the next story/account and return to the previous page when all stories are shown.

## Installation

### Prerequisites

- Flutter SDK: Installation Guide
- Dart SDK (included with Flutter SDK)
- Android Studio (for Android emulator) or Xcode (for iOS simulator)

### Running the App

#### Via Terminal

1.  Clone the repository:

    ```
    git clone https://github.com/nashua354/instagram_clone.git
    cd instagram_clone
    ```

2.  Get the dependencies:

    ```
    flutter pub get
    ```

3.  Run the app:

    ```
    flutter run
    ```

    This command will launch the app on the connected device or emulator.

#### Via APK

1.  Build the APK:

    ```
    flutter build apk --release
    ```

2.  Navigate to the APK directory:

    ```
    cd build/app/outputs/flutter-apk/
    ```

3.  Install the APK on an Android device:

    ```
    adb install app-release.apk
    ```

    Make sure you have `adb` installed and your device is connected via USB with USB debugging enabled.
