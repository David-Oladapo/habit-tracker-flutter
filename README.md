# Habit Tracker

A simple and fun **Flutter** app to help you track your daily habits and build streaks over time. Keep tabs on your routines, mark them as done, edit, or delete habits, and watch your progress grow!

---

## Features

* Add, edit, and delete habits.
* Mark habits as done and see your streak increase.
* Animations for a smooth and enjoyable UI.
* Input validation to prevent empty habits.
* Light and visually appealing color scheme.

---

## Directory Structure

```
habit_tracker/
│
├── lib/
│   ├── main.dart
│   ├── models/
│   │   └── habit.dart
│   ├── screens/
│   │   └── home_screen.dart
│   ├── services/
│   │   └── habit_storage.dart
│   └── widgets/
│       └── habit_tile.dart
│
├── pubspec.yaml
└── README.md
```

---

## Installation

1. Clone the repository:

```bash
git clone <your-repo-url>
```

2. Navigate to the project directory:

```bash
cd habit_tracker
```

3. Install dependencies:

```bash
flutter pub get
```

4. Run the app on an emulator or device:

```bash
flutter run
```

---

## Building APK

To generate a release APK for deployment:

```bash
flutter build apk --release
```

The APK will be available at:

```
build/app/outputs/flutter-apk/app-release.apk
```

---

## Problems Encountered & Solutions

1. **Inputting empty habits:**

   * Solved by adding input validation to prevent empty habit entries.

2. **App UI lag when adding animations:**

   * Solved by using lightweight, subtle animations that do not block the main thread.

3. **Persistent storage issues:**

   * Solved by implementing `SharedPreferences` for saving and loading habit data reliably.

---

## Work Contributions

1. **Core Flutter app setup and main UI design**
2. **Habit model and storage system**
3. **HabitTile widget with animations**
4. **Input validation and dialog management**
5. **FAB animation and streak animations**
6. **Bug fixing and app testing**
7. **Documentation and README preparation**

---

## Screenshots

---

## Contribution

Contributions are welcome! You can:

* Suggest new features
* Report bugs
* Improve UI/UX
* Add more animations without affecting performance

---

## License

This project is open source and available under the MIT License.
