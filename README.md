# macOS Shortcut Tips 💡

A lightweight macOS background utility that detects Control-based shortcuts (Ctrl+C, Ctrl+V, Ctrl+A)
and shows native notification banners reminding you to use macOS ⌘ shortcuts instead.

## What it does
- Detects: Ctrl+C / Ctrl+V / Ctrl+A (global keyboard monitoring)
- Displays: macOS notification banners (non-blocking)
- Prevents spam using a cooldown

## Permissions
This app requires:
- **Accessibility**: to detect global keyboard input
- **Notifications**: to display banners

## How to run (developer)
1. Open the Xcode project
2. Build the app (Product → Build)
3. Copy the built `.app` into `/Applications`
4. Enable Accessibility permission for the app
5. Launch the app from `/Applications`

## Tech stack
- Swift
- AppKit (`Cocoa`)
- UserNotifications

## Motivation
Built to help users switching from Windows/Linux develop macOS-native keyboard habits.
