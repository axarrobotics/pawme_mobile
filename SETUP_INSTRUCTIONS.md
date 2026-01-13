# PawMe App - Setup Instructions

## ✅ Completed Changes

### 1. **New Theme & Branding**
- Primary color: `#02ADA9` (teal/turquoise)
- Clean white background with modern UI
- All colors defined in `lib/constants/app_colors.dart`
- Theme configuration in `lib/constants/app_theme.dart`

### 2. **Authentication Flow**
The app now has a complete onboarding flow:

1. **Splash Screen** (`lib/screens/splash_screen.dart`)
   - White background with PawMe logo
   - Checks if user is already authenticated
   - Navigates to Welcome or Home screen

2. **Welcome Screen** (`lib/screens/welcome_screen.dart`)
   - Two options: Email signup or Google sign-in
   - Modern, clean design

3. **Email Registration** (`lib/screens/email_registration_screen.dart`)
   - Email and password input
   - Password confirmation
   - Sends verification email

4. **Email Verification** (`lib/screens/email_verification_screen.dart`)
   - Waits for user to verify email
   - Auto-checks verification status every 3 seconds
   - Resend email option with 60-second cooldown

5. **Google Sign-In** (`lib/screens/google_signin_screen.dart`)
   - One-tap Google authentication
   - Saves user data to Firebase Realtime Database

6. **Home Page** (`lib/screens/home_page.dart`)
   - Updated with new theme colors
   - Light background instead of dark
   - Robot control dashboard

### 3. **Authentication Service**
- Centralized auth logic in `lib/services/auth_service.dart`
- Handles email/password registration
- Email verification
- Google Sign-In
- User data persistence to Firebase Database

### 4. **iOS Configuration**
- Bundle ID: `com.axarsoft.pawme`
- Display Name: **PawMe**
- iOS Deployment Target: **15.0**
- Google Sign-In URL scheme configured
- Firebase GoogleService-Info.plist added

---

## 🎨 Required: Add Logo Images

You need to add **3 images** to the `assets/images/` folder:

### 1. **pawme_logo.png** (REQUIRED)
- The PawMe logo with dog and cat yin-yang design
- Save the image you provided as: `assets/images/pawme_logo.png`
- Recommended size: 512x512px or larger (will be scaled down)

### 2. **google_logo.png** (REQUIRED)
- Google's logo for the sign-in button
- Download from: https://www.gstatic.com/images/branding/product/1x/googleg_48dp.png
- Save as: `assets/images/google_logo.png`

### 3. **robot.png** (Optional)
- Robot image if you want to add it back to any screen
- Save as: `assets/images/robot.png`

---

## 🚀 How to Run the App

### Step 1: Add the Logo Images
```bash
# Navigate to your project
cd /Users/ashokjaiswal/Development/AYWA/Development/App/pawme_mobile

# The assets/images folder already exists
# Just copy your logo files there:
# - assets/images/pawme_logo.png
# - assets/images/google_logo.png
```

### Step 2: Run on Device
```bash
# Make sure you're on the wip branch
git branch

# Run on your iPhone
flutter run -d 00008101-000978292690001E
```

Or open in Xcode:
```bash
open ios/Runner.xcworkspace
```
Then click the Run button (▶️) in Xcode.

---

## 📱 User Flow

1. **App Launch** → Splash screen (2 seconds)
2. **Not Authenticated** → Welcome screen
   - Option A: **Sign up with Email**
     - Enter email & password
     - Receive verification email
     - Click link in email
     - Auto-redirected to Home
   - Option B: **Continue with Google**
     - One-tap sign-in
     - Immediately go to Home
3. **Authenticated** → Home page (robot dashboard)

---

## 🎨 App Icon Setup (Future)

To create proper app icons from your logo:

1. Use a tool like https://appicon.co/
2. Upload your `pawme_logo.png`
3. Download the iOS icon set
4. Replace contents of `ios/Runner/Assets.xcassets/AppIcon.appiconset/`

---

## 🔧 Troubleshooting

### "Unable to load asset" error
- Make sure all 3 image files are in `assets/images/`
- Run `flutter clean` then `flutter pub get`

### Build fails
- Run `flutter clean`
- Delete `ios/Pods` and `ios/Podfile.lock`
- Run `cd ios && pod install`
- Try building again

### Email verification not working
- Check Firebase Console → Authentication → Sign-in method
- Make sure Email/Password is enabled
- Check spam folder for verification email

### Google Sign-In crashes
- Verify `GoogleService-Info.plist` is in `ios/Runner/`
- Check that URL scheme is in `Info.plist` (already configured)
- Make sure Google Sign-In is enabled in Firebase Console

---

## 📝 Firebase Setup Checklist

✅ Firebase project created (`pawme-457f6`)  
✅ iOS app registered (Bundle ID: `com.axarsoft.pawme`)  
✅ GoogleService-Info.plist downloaded and added  
✅ Authentication methods enabled:
  - Email/Password ✅
  - Google ✅
  - Apple (you mentioned it's enabled)  
✅ Realtime Database created  

---

## 🎯 Next Steps

1. **Add the logo images** (see above)
2. **Test the complete flow**:
   - Email registration → verification → home
   - Google sign-in → home
   - Logout → welcome screen
3. **Customize home page** with your robot features
4. **Add Apple Sign-In** if needed (currently only Email & Google are implemented)

---

## 📂 Project Structure

```
lib/
├── constants/
│   ├── app_colors.dart      # Theme colors (#02ADA9)
│   └── app_theme.dart        # Material theme config
├── screens/
│   ├── splash_screen.dart
│   ├── welcome_screen.dart
│   ├── email_registration_screen.dart
│   ├── email_verification_screen.dart
│   ├── google_signin_screen.dart
│   └── home_page.dart
├── services/
│   └── auth_service.dart     # Authentication logic
└── main.dart                 # App entry point
```

---

**Build Status:** ✅ **SUCCESS**  
**Theme Color:** `#02ADA9`  
**Ready to run:** Once logo images are added
