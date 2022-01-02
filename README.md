# todoaholic

A minimalist open-source and free todo app for iOS, Android, macOS & web.

## Get the app
- iOS (coming soon)
- Android (coming soon)
- macOS (coming soon)
- [web](https://todoaholic.com/)

## Tech Stack

### Frontend:
- [Flutter](https://flutter.dev/)

### Backend:
- Auth: [Firebase Auth](https://firebase.google.com/products/auth)
- DB: [Firestore](https://firebase.google.com/products/firestore)
- [Firebase Cloud Functions](https://firebase.google.com/docs/functions)
  - Custom schedule function that runs once every week to check for users that have been inactive for three months and removes them. Their user data is then removed by this extension: [Firebase Delete User Data Extension](https://firebase.google.com/products/extensions/firebase-delete-user-data).

### Hosting (web):
- [Firebase Hosting](https://firebase.google.com/docs/hosting) with a custom [GitHub Action](https://github.com/features/actions) that auto builds the Flutter web app, and deploys it when there is a push to the master branch or a PR merge.

### Services used:
- [Firebase Analytics](https://firebase.google.com/products/analytics)
- [Firebase Crashlytics](https://firebase.google.com/products/crashlytics)
- [Firebase Performance Monitoring](https://firebase.google.com/products/performance)
