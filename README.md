<img src="resources/icon/todoaholic-icon-macos.png" width="250" >

# todoaholic

A minimalist open-source and free todo app for iOS, Android, macOS & web.

<a href="https://www.buymeacoffee.com/andordavoti" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" style="height: 60px !important;width: 217px !important;" ></a>

## Get the app

- iOS: [App Store](https://apps.apple.com/us/app/todoaholic/id1601535769)
- Android: [Google Play Store](https://play.google.com/store/apps/details?id=com.andordavoti.todoaholic)
- macOS: only in TestFlight for now
- Windows: see future plans section
- Linux: see future plans section
- web (PWA): [todoaholic.com](https://todoaholic.com/)

## Features

Manage tasks cross-platform in real-time. No need to refresh the browser if you made a change through the mobile app. Everything syncs across all of your devices in real-time automatically.

Create custom lists (ex. shopping list, bucket list, reading list, movie list).

<details>
<summary>Intuitive gestures to cross out, move, remove and edit tasks.</summary>
  <ul>
    <li>Tap a task to cross it of your list</li>
    <li>Slide a task to the right to move it to the next day</li>
    <li>Slide an undone task to the left to edit it</li>
    <li>Slide a done task to the left to delete it</li>
    <li>Slide a list in the drawer to the left to edit or remove it</li>
  </ul>
</details>

Task timeline. Get an overview of what you have going on in the coming days.

Offline support for the mobile and desktop apps.

<details>
<summary>Keyboard shortcuts for desktop and web.</summary>
  <ul>
    <li>Navigate the day you are viewing on the home screen with the left and right arrow keys (current date with arrow down, one week forward with arrow up)</li>
    <li>Press "A" or "+" on the task or custom list screen to quickly add a task</li>
    <li>Press "H" to go "home" and view your current tasks</li>
    <li>Press "T" to view the timeline</li>
    <li>Press "P" to view your profile</li>
  </ul>
</details>

## Future plans

- Support Windows & Linux (will be added when FlutterFire is supported on the platforms: [FlutterFire Desktop](https://github.com/invertase/flutterfire_desktop))
- Calendar integration
- Recurring tasks (tasks that repeat every day, week or month)
- Sign in with Apple, Google, GitHub, etc.

## Known issues

- Reordering tasks is not working properly for now.

## Tech Stack

### Frontend:

- [Flutter](https://flutter.dev/)

### Backend:

**Auth:** [Firebase Auth](https://firebase.google.com/products/auth)

<details>
  <summary><strong>DB:</strong> <a href="https://firebase.google.com/products/firestore">Firestore</a></summary>

  <ul>
    <lh><strong>Composite indexes on collection ID "todos":</strong></lh>
    <li>date Ascending, isDone Ascending, order Ascending</li>
    <li>date Ascending, order Ascending, isDone Ascending</li>
    <li>date Ascending, order Ascending, isDone Descending</li>
    <li>isDone Ascending, date Ascending</li>
    <li>isDone Ascending order Ascending</li>
  </ul>
</details>

<details>
  <summary><a href="https://firebase.google.com/docs/functions">Firebase Cloud Functions</a></summary>

Custom schedule function that runs once every week to check for users that have been inactive for three months and removes them. Their user data is then removed by this extension: <a href="https://firebase.google.com/products/extensions/firebase-delete-user-data">Firebase Delete User Data Extension</a>.

</details>

## CI/CD pipelines

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
