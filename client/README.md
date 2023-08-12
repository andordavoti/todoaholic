# todoaholic client

## Getting Started

This is a Flutter project. To set up your environment, please refer to [this guide](https://docs.flutter.dev/get-started/install).

To run the app, open the `main.dart` file in the `lib` directory and run the following command:

```sh
flutter run
```

## Production Build

### **Android**

Build app bundle (for Google Play Store submission):

```sh
flutter build appbundle
```

Build APK (for sideloading):

```sh
flutter build apk --split-per-abi
```

### **iOS & macOS**

Open the project in xcode with the following command:

**iOS**

```sh
open ios/Runner.xcworkspace
```

Then in the menu bar, select `Product -> Archive`.

### **web**

Run the following command:

```sh
flutter build web
```

## Generate new native launcher icons

### **Android**

Update the icon located at: /resources/icon/todoaholic-icon.png

Then run:

```sh
flutter pub run flutter_launcher_icons:main
```

### **iOS & macOS**

Use [this app](https://apps.apple.com/us/app/icon-set-creator/id939343785), drag in the icon and generate the icons.

Then open the project in xcode with the following command:

**iOS**

```sh
open ios/Runner.xcworkspace
```

Go to the Assets -> AppIcon in xcode, and drag in the icons.

### **web**

Use [this tool](https://realfavicongenerator.net/) to generate the icons. Then replace the icons in web/icons.

## Generate new native splash screens

### **iOS, Android and web**

```sh
flutter pub run flutter_native_splash:create
```

### Removing the splash screen

```sh
flutter pub run flutter_native_splash:remove
```
