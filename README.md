# JSAppleSignIn
# 🍎 Sign in with Apple Demo (iOS)
This repository provides a simple demo of implementing Sign in with Apple in an iOS app using Swift. It demonstrates how to integrate the authentication flow, handle the authorization result, and fetch the user's name and email on first sign-in.

# 🚀 Features
• Native Apple Sign-In button

• Handles first-time and returning user authentication

• Retrieves user information (name, email) and display them

• Simple UI for demonstration purposes

• Compatible with iOS 13 and later

# 🧰 Requirements
• Xcode 14+

• iOS 13+

• Swift 5+

• Apple Developer Account (with Sign in with Apple enabled)

• App ID with Sign in with Apple capability

# 📄 Code Overview
• AppleSignInVC.swift: Displays the Apple Sign-In button and handles the authentication flow. It contains logic to perform Sign in with Apple and manage tokens. Also displays name, email and user identifier.

# 🧪 Testing Notes
• First-time sign-ins provide the full name and email.

• Subsequent logins return only the user ID.

• For testing multiple sign-ins, revoke access from Apple ID account page.

# 📚 Resources
• Apple Developer Docs - Sign in with Apple

• Sign in with Apple in Swift – Hacking with Swift

• Usage of Keychain to save name and email - SwiftKeychainWrapper
