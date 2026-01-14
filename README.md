# PawMe Mobile

Control your robot companion with ease and stay connected wherever you are.

## 🔐 Security Setup (IMPORTANT - Read First!)

**Firebase credentials are NOT included in this repository for security reasons.**

### First Time Setup:

1. **Run the setup script:**
   ```bash
   ./scripts/setup_firebase.sh
   ```
   This will create `.env.local` from the template.

2. **Get Firebase configuration files:**
   - Contact the project admin for:
     - `google-services.json` (Android)
     - `GoogleService-Info.plist` (iOS)
   - Or download from [Firebase Console](https://console.firebase.google.com/)

3. **Place files in correct locations:**
   - Android: `android/app/google-services.json`
   - iOS: `ios/Runner/GoogleService-Info.plist`

4. **Never commit these files!** They're already in `.gitignore`
   - `.env.local` is protected
   - Firebase config files are protected

📖 **Full security documentation:** See [SECURITY_SETUP.md](SECURITY_SETUP.md)

## Getting Started

This is a Flutter application for controlling PawMe robots.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

Screen 1 - Slash screen
Screen 2 - Welcome screen
Screen 3 - Login screen
Screen 4 - Register screen
Screen 5 - Home screen
Screen 6 - Robot profile screen with list of robots and on top Add New Robot button
Screen 7 - Robot detail screen
Screen 8 - Robot settings screen
Screen 9 - Instruction, we will now add a new robot (Continue Button) (when clicked on Add New Robot button)
Screen 10 - Title: Enable Pairing Mode ( Subtitle: Follow the instructions to enable pairing mode on your robot)
Screen 11 - Press and hold the pairing button on your robot for 5 seconds
Screen 12 - Your robot is now in pairing mode
Screen 13 - Choose the Roboto Wifi network from the list below Starting with PawMe-XXXX (XXXX MacID of the robot)
Scren 14 - Choose your home network from the list below
Screen 15 - Enter your home network password
Screen 16 - Connecting Robot to your home network
Screen 17 - Robot connected to your home network (or failed)
load screen Screen 6 - Robot profile screen with list of robots and on top Add New Robot button


Bottom Menus

Feed | Recomote | Home | Reels | Settings 

Feed - Show the video feed
Recomote - Show the remote control
Home - Show the home screen
Reels - Show the reels (daily capture of moments from device camers, saved on firebase bucket / storage)
Settings - Show the settings screen

(Right now login with email uses firebase auth, sends user link to confirm the account, later to be replaced with 6 digit code (which basically is a firebase cloud function that would be triggered when an account is added in firebase, this will generate a number saved in the firebase, when user enters this code, it will be validated with the firebase and if valid, the user will be logged in)


# Navigate to project directory
cd /Users/ashokjaiswal/Development/AYWA/Development/App/pawme_mobile
# List available simulators
flutter devices
# Run on a specific simulator (iPhone 16 Pro)
flutter run -d "iPhone 16 Pro"
# Or just run on any available simulator
flutter run

# Clean the build
flutter clean
# Get dependencies
flutter pub get
# Run again
flutter run