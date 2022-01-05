<img src="resources/icon/todoaholic-icon.png" width="250" >

# todoaholic

A minimalist open-source and free todo app for iOS, Android, macOS & web.

## Get the app

- iOS (coming soon)
- Android (coming soon)
- macOS (coming soon)
- web (PWA): [todoaholic.com](https://todoaholic.com/)

## Tech Stack

### Frontend:

- [Flutter](https://flutter.dev/)

### Backend:

- Auth: [Firebase Auth](https://firebase.google.com/products/auth)
- DB: [Firestore](https://firebase.google.com/products/firestore)
  - Composite indexes on collection ID "todos":
    -     date Ascending, isDone Ascending, order Ascending
    -     date Ascending, order Ascending, isDone Ascending
    - date Ascending, order Ascending, isDone Descending
    - isDone Ascending, date Ascending
- [Firebase Cloud Functions](https://firebase.google.com/docs/functions)
  - Custom schedule function that runs once every week to check for users that have been inactive for three months and removes them. Their user data is then removed by this extension: [Firebase Delete User Data Extension](https://firebase.google.com/products/extensions/firebase-delete-user-data).

## Deployment (CI/CD pipeline)

### iOS:

A [GitHub Action](https://github.com/features/actions) automatically builds the Flutter iOS app with [Fastlane](https://fastlane.tools/), and deploys it to TestFlight throught the App Store Connect API when there is a push to the master branch or a PR merge.

### Android:

(coming soon)

### macOS:

(coming soon)

### web:

A [GitHub Action](https://github.com/features/actions) automatically builds the Flutter web app, and deploys it to [Firebase Hosting](https://firebase.google.com/docs/hosting) when there is a push to the master branch or a PR merge. There is also a [GitHub Action](https://github.com/features/actions) that deploys a preview of the app for the PR for testing before you merge to master.

### Services used:

- [Firebase Analytics](https://firebase.google.com/products/analytics)
- [Firebase Crashlytics](https://firebase.google.com/products/crashlytics)
- [Firebase Performance Monitoring](https://firebase.google.com/products/performance)
