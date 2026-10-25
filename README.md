# Smart Campus / College Companion App

Android app built with Flutter that keeps a student's college information in one place. It works fully offline.

**Developer:** Abhishek (NN25MCA002), Department of MCA, NMAM Institute of Technology, Nitte

## Features
- **Dashboard:** today's classes, pending assignments and the latest notice
- **Timetable:** weekly schedule with day-wise tabs; add classes with room and time
- **Attendance:** mark Present/Absent per subject; percentage shown, in red when below 75%
- **Notice Board:** post and view notices, newest first
- **Assignments:** add with due date, mark complete, overdue ones highlighted

## Tech stack
Flutter (Dart), Provider (state management), Hive (local offline database), uuid, intl, fl_chart

## Project structure
- `lib/models` - data classes
- `lib/providers` - app state and Hive storage
- `lib/screens` - the five app screens
- `lib/main.dart` - app entry point

## How to run
1. Install the Flutter SDK and Android Studio (with an emulator)
2. Download or clone this repository
3. In the project folder run: `flutter create .` (adds the android folder)
4. Run: `flutter pub get`
5. Start an emulator or connect a phone, then run: `flutter run`
