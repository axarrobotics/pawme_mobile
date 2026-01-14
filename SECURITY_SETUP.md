# Security Setup Guide

## Firebase Credentials Management

This project uses Firebase for authentication and backend services. To keep credentials secure:

### 1. Local Development Setup

1. **Copy the example environment file:**
   ```bash
   cp .env.example .env.local
   ```

2. **Get your Firebase credentials:**
   - Go to [Firebase Console](https://console.firebase.google.com/)
   - Select your project
   - Go to Project Settings
   - Download configuration files:
     - For Android: `google-services.json`
     - For iOS: `GoogleService-Info.plist`

3. **Place configuration files:**
   - Android: `android/app/google-services.json`
   - iOS: `ios/Runner/GoogleService-Info.plist`

4. **Fill in .env.local file** with values from your Firebase config files

### 2. Team Setup

When a new team member joins:

1. They should request Firebase configuration files from the project admin
2. Place files in the correct locations (see above)
3. Never commit these files to version control

### 3. CI/CD Setup

For automated builds:

1. **GitHub Actions / GitLab CI:**
   - Store Firebase config files as encrypted secrets
   - Use environment variables to inject credentials during build

2. **Example GitHub Actions:**
   ```yaml
   - name: Create google-services.json
     run: echo '${{ secrets.GOOGLE_SERVICES_JSON }}' > android/app/google-services.json
   
   - name: Create GoogleService-Info.plist
     run: echo '${{ secrets.GOOGLE_SERVICE_INFO_PLIST }}' > ios/Runner/GoogleService-Info.plist
   ```

### 4. Security Best Practices

✅ **DO:**
- Keep `.env` and Firebase config files in `.gitignore`
- Use environment-specific configurations (dev, staging, prod)
- Rotate API keys regularly
- Use Firebase App Check for additional security
- Enable Firebase Security Rules

❌ **DON'T:**
- Commit API keys or credentials to version control
- Share credentials via email or chat
- Use production credentials in development
- Hardcode API keys in source code

### 5. What's Already Protected

The following files are now in `.gitignore`:
- `android/app/google-services.json`
- `ios/Runner/GoogleService-Info.plist`
- `ios/GoogleService-Info.plist`
- `.env.local`
- `.env.*.local` (except `.env.local.example`)

### 6. If Credentials Were Already Committed

If you've already committed sensitive files to Git:

1. **Remove from Git history:**
   ```bash
   git filter-branch --force --index-filter \
     "git rm --cached --ignore-unmatch android/app/google-services.json" \
     --prune-empty --tag-name-filter cat -- --all
   
   git filter-branch --force --index-filter \
     "git rm --cached --ignore-unmatch ios/Runner/GoogleService-Info.plist" \
     --prune-empty --tag-name-filter cat -- --all
   ```

2. **Rotate all API keys** in Firebase Console

3. **Force push** (⚠️ coordinate with team):
   ```bash
   git push origin --force --all
   ```

### 7. Additional Security Measures

Consider implementing:

1. **Firebase App Check** - Protects backend resources from abuse
2. **API Key Restrictions** - Limit API keys to specific apps/domains
3. **Environment Variables** - Use flutter_dotenv for runtime config
4. **Secret Management** - Use tools like Google Secret Manager for production

### 8. Monitoring

- Enable Firebase Security Rules
- Monitor Firebase Console for unusual activity
- Set up alerts for authentication failures
- Review API usage regularly

## Need Help?

Contact the project admin for:
- Firebase configuration files
- Access to Firebase Console
- CI/CD setup assistance
