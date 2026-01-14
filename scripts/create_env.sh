#!/bin/bash

# Script to create .env.local file from Firebase configuration files
# This extracts values from google-services.json and GoogleService-Info.plist

set -e

echo "🔧 Creating .env.local file from Firebase configurations..."
echo ""

# Check if we're in the project root
if [ ! -f "pubspec.yaml" ]; then
    echo "❌ Error: Please run this script from the project root directory"
    exit 1
fi

# Check if configuration files exist
if [ ! -f "android/app/google-services.json" ]; then
    echo "❌ Error: android/app/google-services.json not found"
    exit 1
fi

if [ ! -f "ios/Runner/GoogleService-Info.plist" ]; then
    echo "❌ Error: ios/Runner/GoogleService-Info.plist not found"
    exit 1
fi

# Extract values from google-services.json (requires jq)
if ! command -v jq &> /dev/null; then
    echo "⚠️  Warning: jq is not installed. Install it with: brew install jq"
    echo "   Falling back to manual .env.local creation..."
    cp .env.example .env.local
    echo "✅ Created .env.local from template. Please fill in values manually."
    exit 0
fi

# Extract Android values
PROJECT_ID=$(jq -r '.project_info.project_id' android/app/google-services.json)
PROJECT_NUMBER=$(jq -r '.project_info.project_number' android/app/google-services.json)
STORAGE_BUCKET=$(jq -r '.project_info.storage_bucket' android/app/google-services.json)
ANDROID_APP_ID=$(jq -r '.client[0].client_info.mobilesdk_app_id' android/app/google-services.json)
ANDROID_API_KEY=$(jq -r '.client[0].api_key[0].current_key' android/app/google-services.json)
ANDROID_CLIENT_ID=$(jq -r '.client[0].oauth_client[0].client_id' android/app/google-services.json)
WEB_CLIENT_ID=$(jq -r '.client[0].oauth_client[1].client_id' android/app/google-services.json)
PACKAGE_NAME=$(jq -r '.client[0].client_info.android_client_info.package_name' android/app/google-services.json)

# Extract iOS values (requires PlistBuddy on macOS)
if command -v /usr/libexec/PlistBuddy &> /dev/null; then
    IOS_API_KEY=$(/usr/libexec/PlistBuddy -c "Print :API_KEY" ios/Runner/GoogleService-Info.plist)
    IOS_CLIENT_ID=$(/usr/libexec/PlistBuddy -c "Print :CLIENT_ID" ios/Runner/GoogleService-Info.plist)
    IOS_APP_ID=$(/usr/libexec/PlistBuddy -c "Print :GOOGLE_APP_ID" ios/Runner/GoogleService-Info.plist)
    BUNDLE_ID=$(/usr/libexec/PlistBuddy -c "Print :BUNDLE_ID" ios/Runner/GoogleService-Info.plist)
else
    echo "⚠️  Warning: PlistBuddy not available. Using Android values for iOS."
    IOS_API_KEY=$ANDROID_API_KEY
    IOS_CLIENT_ID=$ANDROID_CLIENT_ID
    IOS_APP_ID=$ANDROID_APP_ID
    BUNDLE_ID=$PACKAGE_NAME
fi

# Create .env.local file
cat > .env.local << EOF
# Firebase Configuration
# Auto-generated from Firebase configuration files
# DO NOT commit this file to version control

# Firebase Project Info
FIREBASE_PROJECT_ID=$PROJECT_ID
FIREBASE_PROJECT_NUMBER=$PROJECT_NUMBER
FIREBASE_STORAGE_BUCKET=$STORAGE_BUCKET

# Android Configuration
ANDROID_MOBILESDK_APP_ID=$ANDROID_APP_ID
ANDROID_API_KEY=$ANDROID_API_KEY
ANDROID_CLIENT_ID=$ANDROID_CLIENT_ID
ANDROID_PACKAGE_NAME=$PACKAGE_NAME

# iOS Configuration
IOS_MOBILESDK_APP_ID=$IOS_APP_ID
IOS_API_KEY=$IOS_API_KEY
IOS_CLIENT_ID=$IOS_CLIENT_ID
IOS_BUNDLE_ID=$BUNDLE_ID

# Google Sign-In
GOOGLE_WEB_CLIENT_ID=$WEB_CLIENT_ID
EOF

echo "✅ .env.local file created successfully!"
echo ""
echo "📋 Extracted configuration:"
echo "   Project ID: $PROJECT_ID"
echo "   Project Number: $PROJECT_NUMBER"
echo "   Package Name: $PACKAGE_NAME"
echo ""
echo "⚠️  Remember: Never commit .env.local to version control!"
