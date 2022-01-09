<img src="resources/icon/todoaholic-icon-macos.png" width="250" >

# todoaholic

A minimalist open-source and free todo app for iOS, Android, macOS & web.

## Get the app

- iOS (coming soon)
- Android: [Google Play Store](https://play.google.com/store/apps/details?id=com.andordavoti.todoaholic)
- macOS (coming soon)
- web (PWA): [todoaholic.com](https://todoaholic.com/)

## Features

- Manage tasks cross-platform in real-time. No need to refresh the browser if you made a change through the mobile app. Everything syncs across all of your devices in real-time automatically.
- Intuitive gestures to cross out, move, remove and edit tasks.
  - Tap a task to cross it of your list
  - Slide a task to the right to move it to the next day
  - Slide an undone task to the left to edit it
  - Slide a done task to the left to delete it
- Task timeline. Get an overview of what you have going on in the coming days.
- Offline support for the mobile and desktop apps.
- Keyboard shortcuts for desktop and web:
  - Navigate the day you are viewing on the home screen with the left and right arrow keys
  - Press "A" or "+" on the home screen to quickly add a task
  - Press "T" on the home screen to view the timeline
  - Press "ESC" to go back

## Tech Stack

### Frontend:

- [Flutter](https://flutter.dev/)

### Backend:

- Auth: [Firebase Auth](https://firebase.google.com/products/auth)
- DB: [Firestore](https://firebase.google.com/products/firestore)
  - Composite indexes on collection ID "todos":
    - date Ascending, isDone Ascending, order Ascending
    - date Ascending, order Ascending, isDone Ascending
    - date Ascending, order Ascending, isDone Descending
    - isDone Ascending, date Ascending
- [Firebase Cloud Functions](https://firebase.google.com/docs/functions)
  - Custom schedule function that runs once every week to check for users that have been inactive for three months and removes them. Their user data is then removed by this extension: [Firebase Delete User Data Extension](https://firebase.google.com/products/extensions/firebase-delete-user-data).

## Deployment (CI/CD pipeline)

### iOS:

A [GitHub Action](https://github.com/features/actions) automatically builds the Flutter iOS app with [Fastlane](https://fastlane.tools/), and deploys it to TestFlight throught the App Store Connect API when there is a push to the master branch or a PR merge.

### Android:

A [GitHub Action](https://github.com/features/actions) automatically builds the Flutter Android app bundle, and deploys it to Google Play Store Internal Test Track with [Fastlane](https://fastlane.tools/), when there is a push to the master branch or a PR merge.

### macOS:

Manual build and deployment through Xcode for now...

### web:

A [GitHub Action](https://github.com/features/actions) automatically builds the Flutter web app, and deploys it to [Firebase Hosting](https://firebase.google.com/docs/hosting) when there is a push to the master branch or a PR merge. There is also a [GitHub Action](https://github.com/features/actions) that deploys a preview of the app for the PR for testing before you merge to master.

### Other services used:

- [Firebase Analytics](https://firebase.google.com/products/analytics)
- [Firebase Crashlytics](https://firebase.google.com/products/crashlytics)
- [Firebase Performance Monitoring](https://firebase.google.com/products/performance)
