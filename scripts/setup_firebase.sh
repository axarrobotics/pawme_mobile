#!/bin/bash

# Firebase Configuration Setup Script
# This script helps set up Firebase configuration files securely

set -e

echo "🔐 Firebase Configuration Setup"
echo "================================"
echo ""

# Check if running from project root
if [ ! -f "pubspec.yaml" ]; then
    echo "❌ Error: Please run this script from the project root directory"
    exit 1
fi

# Check if .env.example exists
if [ ! -f ".env.example" ]; then
    echo "❌ Error: .env.example file not found"
    exit 1
fi

# Create .env.local if it doesn't exist
if [ ! -f ".env.local" ]; then
    echo "📝 Creating .env.local file from .env.example..."
    cp .env.example .env.local
    echo "✅ .env.local file created"
    echo ""
    echo "⚠️  Please edit .env.local file and add your Firebase credentials"
    echo ""
else
    echo "ℹ️  .env.local file already exists"
fi

# Check for Android google-services.json
echo "Checking Android configuration..."
if [ ! -f "android/app/google-services.json" ]; then
    echo "❌ android/app/google-services.json not found"
    echo "   Please download it from Firebase Console and place it at:"
    echo "   android/app/google-services.json"
    MISSING_FILES=true
else
    echo "✅ android/app/google-services.json found"
fi

echo ""

# Check for iOS GoogleService-Info.plist
echo "Checking iOS configuration..."
if [ ! -f "ios/Runner/GoogleService-Info.plist" ]; then
    echo "❌ ios/Runner/GoogleService-Info.plist not found"
    echo "   Please download it from Firebase Console and place it at:"
    echo "   ios/Runner/GoogleService-Info.plist"
    MISSING_FILES=true
else
    echo "✅ ios/Runner/GoogleService-Info.plist found"
fi

echo ""
echo "================================"

if [ "$MISSING_FILES" = true ]; then
    echo ""
    echo "📋 Next Steps:"
    echo "1. Go to Firebase Console: https://console.firebase.google.com/"
    echo "2. Select your project"
    echo "3. Go to Project Settings"
    echo "4. Download configuration files for Android and iOS"
    echo "5. Place them in the locations mentioned above"
    echo "6. Run this script again to verify"
    echo ""
    exit 1
else
    echo ""
    echo "✅ All Firebase configuration files are in place!"
    echo ""
    echo "⚠️  Remember:"
    echo "   - Never commit these files to version control"
    echo "   - They are already in .gitignore"
    echo "   - Share them securely with team members only"
    echo ""
fi
