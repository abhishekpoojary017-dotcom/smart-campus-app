# Smart Campus App

A Flutter college companion app: timetable, attendance tracker, notice board, and assignment tracker.
Data is stored locally on-device using Hive (works fully offline, no backend setup required to get started).

## What's included

```
lib/
  models/          -> data classes (Subject, TimetableEntry, AttendanceRecord, Notice, Assignment)
  providers/        -> AppDataProvider: all state management + Hive read/write logic
  screens/           -> HomeScreen (dashboard), TimetableScreen, AttendanceScreen, NoticesScreen, AssignmentsScreen
  main.dart          -> app entry point
pubspec.yaml         -> dependencies
```

## IMPORTANT — this zip has no android/ios folders yet

This zip contains only the Dart source code (`lib/`) and `pubspec.yaml`, because generating
the native Android/iOS project wrapper requires the Flutter SDK, which isn't available in the
environment that built this. You need to generate that wrapper yourself — takes 2 minutes.

## Setup steps

1. **Install Flutter SDK** (if not already installed): https://docs.flutter.dev/get-started/install
   Verify with:
   ```
   flutter doctor
   ```

2. **Create a new empty Flutter project** in a fresh folder:
   ```
   flutter create smart_campus_app
   cd smart_campus_app
   ```

3. **Replace the generated `lib/` folder and `pubspec.yaml`** with the ones from this zip
   (delete the default `lib/main.dart` first, then copy everything from this zip's `lib/`
   and `pubspec.yaml` into your new project folder, overwriting `pubspec.yaml`).

4. **Install dependencies:**
   ```
   flutter pub get
   ```

5. **Run it** (with an emulator running, or a phone connected via USB with USB debugging on):
   ```
   flutter run
   ```

That's it — the app opens straight into the dashboard with a couple of sample entries
pre-loaded so it's not empty on first launch.

## Next steps to extend it (good for viva/demo talking points)

- **Firebase integration**: swap Hive calls in `AppDataProvider` for Firestore calls to get
  real multi-device sync and a proper admin/student split. The UI layer won't need to change
  since screens only call `AppDataProvider` methods.
- **Push notifications**: add `flutter_local_notifications` or Firebase Cloud Messaging to
  alert students when a new notice is posted or an assignment is due soon.
- **Authentication**: add Firebase Auth or a simple login screen so each student only sees
  their own attendance/assignments.
- **Charts**: `fl_chart` is already in `pubspec.yaml` — you can add a pie/bar chart on the
  Attendance screen to visualize overall attendance across all subjects.

## Tech stack

- Flutter (Dart)
- Provider (state management)
- Hive (local NoSQL storage, offline-first)
- fl_chart (included, ready for charts)
