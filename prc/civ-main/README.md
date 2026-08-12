# Flutter Setup Guide (Windows)

## 1. Download Flutter SDK

* Go to the official Flutter website.
* Download the **Flutter SDK** for Windows.

## 2. Extract the SDK

* Extract the downloaded ZIP file to your preferred location.
* Example:

  ```text
  C:\src\flutter
  ```

## 3. Add Flutter to PATH

1. Open the extracted Flutter folder.
2. Open the **bin** folder.
3. Copy the directory path.
   Example:

   ```text
   C:\src\flutter\bin
   ```
4. Open **Environment Variables**.
5. Search for **Edit the system environment variables**.
6. Click **Environment Variables**.
7. Under **System Variables**, select **Path** and click **Edit**.
8. Click **New** and paste the Flutter **bin** directory.
9. Click **OK** on all windows to save the changes.

---

# Verify Flutter Installation

1. Press **Win + R**.
2. Type:

   ```text
   cmd
   ```
3. Run:

   ```bash
   flutter --version
   ```

If a Flutter version is displayed, Flutter is installed correctly.

---

# Install Android Studio (For Building APKs)

Install Android Studio, then open **SDK Manager** and install the following:

* Android SDK
* Android SDK Build-Tools
* Android SDK Platform-Tools
* Android SDK Command-line Tools (latest)

---

# Verify Android Setup

Open **Command Prompt** and run:

```bash
flutter --version
```

Accept the Android licenses:

```bash
flutter doctor --android-licenses
```

Type **y** for every license prompt.

Finally, verify everything:

```bash
flutter doctor
```

Fix any issues that Flutter Doctor reports before continuing.

---

# Open Your Flutter Project

Navigate to your project folder:

```bash
cd path\to\your\project
```

Install the project dependencies:

```bash
flutter pub get
```

---

# If `flutter pub get` Finishes

Restart the Dart Analysis Server.

1. Press **Ctrl + Shift + P**.
2. Search for:

   ```text
   Dart: Restart Analysis Server
   ```
3. Press **Enter**.
4. Wait about **10–15 seconds** for the project to re-analyze.

---

# Build the APK

Inside your Flutter project, run:

```bash
flutter build apk --release
```

The generated APK will be located at:

```text
build\app\outputs\flutter-apk\app-release.apk
```

---

# Troubleshooting

### Flutter command is not recognized

* Check if the Flutter **bin** folder is added to your PATH.
* Restart Command Prompt or restart your computer.

### Packages have errors after `flutter pub get`

Run:

```bash
flutter clean
flutter pub get
```

Then restart the Dart Analysis Server.

### Android licenses not accepted

Run:

```bash
flutter doctor --android-licenses
```

Accept every prompt by typing:

```text
y
```

### If there are still code errors even after following this README

* Run:

  ```bash
  flutter clean
  flutter pub get
  ```
* Restart the Dart Analysis Server.
* If the errors are still there, check the project's dependencies or plugin versions.
