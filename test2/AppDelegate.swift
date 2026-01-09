import Cocoa
import UserNotifications

@main
class AppDelegate: NSObject, NSApplicationDelegate, UNUserNotificationCenterDelegate {

    private var globalMonitor: Any?
    private var lastTipTime: Date?
    private let cooldownSeconds: TimeInterval = 3

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Run quietly (no Dock focus needed)
        NSApp.setActivationPolicy(.accessory)

        // Close any storyboard-created windows
        NSApp.windows.forEach { $0.close() }

        configureNotifications()
        startGlobalKeyMonitor()

        // Startup proof (will show once notifications are allowed)
        sendTip("Shortcut Tips ✅", "App is running. Try Ctrl+C / Ctrl+V / Ctrl+A.")
    }

    func applicationWillTerminate(_ notification: Notification) {
        if let globalMonitor {
            NSEvent.removeMonitor(globalMonitor)
        }
    }

    // MARK: Notifications

    private func configureNotifications() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self

        center.requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let error {
                NSLog("Notification permission error: \(error.localizedDescription)")
            }
            NSLog("Notifications granted: \(granted)")
        }
    }

    // Make banners appear even if macOS thinks app is “active”
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        return [.banner, .sound]
    }

    private func sendTip(_ title: String, _ body: String) {
        // Cooldown prevents spam
        let now = Date()
        if let last = lastTipTime, now.timeIntervalSince(last) < cooldownSeconds { return }
        lastTipTime = now

        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body

        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: nil
        )

        UNUserNotificationCenter.current().add(request)
    }

    // MARK: Global Key Monitor

    private func startGlobalKeyMonitor() {
        globalMonitor = NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { [weak self] event in
            self?.handleKeyDown(event)
        }
    }

    private func handleKeyDown(_ event: NSEvent) {
        let isControl = event.modifierFlags.contains(.control)
        let isCommand = event.modifierFlags.contains(.command)
        if !isControl || isCommand { return }

        // Key codes: A=0, C=8, V=9
        if event.keyCode == 8 {
            sendTip("macOS Shortcut Tip 💡", "Use ⌘ + C to copy on macOS")
        } else if event.keyCode == 9 {
            sendTip("macOS Shortcut Tip 💡", "Use ⌘ + V to paste on macOS")
        } else if event.keyCode == 0 {
            sendTip("macOS Shortcut Tip 💡", "Use ⌘ + A to select all on macOS")
        }
    }
}
