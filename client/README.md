# todoaholic client

## Getting Started

This is a Flutter project. To set up your environment, please refer to [this guide](https://docs.flutter.dev/get-started/install).

To run the app, open the `main.dart` file in the `lib` directory and run the following command:

```sh
flutter run
```

## Generate new launcher icons

### Android

Update the icon located at: /resources/icon/todoaholic-icon.png

Then run:

```sh
flutter pub run flutter_launcher_icons:main
```

### iOS & macOS

Use [this app](https://apps.apple.com/us/app/icon-set-creator/id939343785), drag in the icon and generate the icons.

Then open the project in xcode with the following command:

iOS

```sh
open ios/Runner.xcworkspace
```

macOS

```sh
open macos/Runner.xcworkspace
```

Go to the Assets -> AppIcon in xcode, and drag in the icons.

### web

Use [this tool](https://realfavicongenerator.net/) to generate the icons. Then replace the icons in web/icons.
