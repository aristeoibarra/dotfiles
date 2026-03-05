import Cocoa
import Foundation

// MARK: - Configuration
struct Config: Codable {
    struct App: Codable {
        let name: String
        let bundleId: String
    }
    
    struct Schedule: Codable {
        let startHour: Int
        let startMinute: Int
        let endHour: Int
        let endMinute: Int
    }
    
    let blockedApps: [App]
    let schedule: Schedule
    let snoozeMinutes: Int
    let showNotifications: Bool
}

// MARK: - Focus Blocker
class FocusBlocker {
    private var config: Config
    private var snoozedApps: [String: Date] = [:]
    private var isCurrentlyBlocking: Bool = false
    private var renamedApps: [String: String] = [:] // bundleId -> original path
    
    init(configPath: String) throws {
        let data = try Data(contentsOf: URL(fileURLWithPath: configPath))
        self.config = try JSONDecoder().decode(Config.self, from: data)
    }
    
    func start() {
        let logMessage = """
        🎯 Focus Blocker started
        📱 Blocked apps: \(config.blockedApps.map { $0.name }.joined(separator: ", "))
        ⏰ Schedule: \(config.schedule.startHour):\(String(format: "%02d", config.schedule.startMinute)) - \(config.schedule.endHour):\(String(format: "%02d", config.schedule.endMinute))
        """
        NSLog(logMessage)
        
        // Initial check and setup - this will restore apps if we're outside blocking hours
        checkSchedule()
        
        // Also scan for any .blocked apps that shouldn't be blocked (in case of crashes)
        if !isInBlockingPeriod() {
            restoreAnyBlockedApps()
        }
        
        // Listen for app activation events
        NSWorkspace.shared.notificationCenter.addObserver(
            self,
            selector: #selector(appDidActivate(_:)),
            name: NSWorkspace.didActivateApplicationNotification,
            object: nil
        )
        
        // Listen for app deactivation events
        NSWorkspace.shared.notificationCenter.addObserver(
            self,
            selector: #selector(appDidDeactivate(_:)),
            name: NSWorkspace.didDeactivateApplicationNotification,
            object: nil
        )
        
        // Check every minute if we should be blocking
        Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
            self?.checkSchedule()
        }
        
        RunLoop.main.run()
    }
    
    @objc private func appDidActivate(_ notification: Notification) {
        guard let app = notification.userInfo?[NSWorkspace.applicationUserInfoKey] as? NSRunningApplication else {
            return
        }
        
        guard let bundleId = app.bundleIdentifier,
              isBlocked(bundleId: bundleId),
              isInBlockingPeriod() else {
            return
        }
        
        // Check if app is snoozed
        if let snoozeUntil = snoozedApps[bundleId], Date() < snoozeUntil {
            return
        }
        
        // Terminate immediately without overlay
        NSLog("🚫 Blocking \(app.localizedName ?? "app")...")
        
        // Send notification before closing
        if config.showNotifications {
            sendNotification(
                title: "App Blocked",
                message: "\(app.localizedName ?? "App") is blocked during your focus time"
            )
        }
        
        // Close the app immediately
        app.terminate()
    }
    
    @objc private func appDidDeactivate(_ notification: Notification) {
        // No longer needed since we terminate immediately
        return
    }
    
    private func sendNotification(title: String, message: String) {
        let script = """
        display notification "\(message)" with title "\(title)" sound name "default"
        """
        
        let task = Process()
        task.launchPath = "/usr/bin/osascript"
        task.arguments = ["-e", script]
        
        do {
            try task.run()
        } catch {
            NSLog("❌ Notification error: \(error)")
        }
    }
    
    private func isBlocked(bundleId: String) -> Bool {
        return config.blockedApps.contains { $0.bundleId == bundleId }
    }
    
    private func isInBlockingPeriod() -> Bool {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.hour, .minute], from: now)
        
        guard let hour = components.hour, let minute = components.minute else {
            return false
        }
        
        let currentMinutes = hour * 60 + minute
        let startMinutes = config.schedule.startHour * 60 + config.schedule.startMinute
        let endMinutes = config.schedule.endHour * 60 + config.schedule.endMinute
        
        // Handle overnight periods (e.g., 23:00 to 04:00)
        if startMinutes > endMinutes {
            return currentMinutes >= startMinutes || currentMinutes < endMinutes
        } else {
            return currentMinutes >= startMinutes && currentMinutes < endMinutes
        }
    }
    
    private func closeBlockedApps() {
        let runningApps = NSWorkspace.shared.runningApplications
        
        for app in runningApps {
            guard let bundleId = app.bundleIdentifier,
                  isBlocked(bundleId: bundleId) else {
                continue
            }
            
            NSLog("🚫 Closing \(app.localizedName ?? "app")...")
            app.terminate()
        }
    }
    
    private func getAppPath(bundleId: String) -> String? {
        let workspace = NSWorkspace.shared
        guard let appURL = workspace.urlForApplication(withBundleIdentifier: bundleId) else {
            return nil
        }
        return appURL.path
    }
    
    private func renameBlockedApps() {
        for app in config.blockedApps {
            guard let appPath = getAppPath(bundleId: app.bundleId) else {
                NSLog("⚠️  Could not find app: \(app.name)")
                continue
            }
            
            let blockedPath = appPath + ".blocked"
            let fileManager = FileManager.default
            
            // Skip if already renamed
            if fileManager.fileExists(atPath: blockedPath) {
                continue
            }
            
            do {
                try fileManager.moveItem(atPath: appPath, toPath: blockedPath)
                renamedApps[app.bundleId] = appPath
                NSLog("🔒 Renamed \(app.name) to hide it")
            } catch {
                NSLog("❌ Failed to rename \(app.name): \(error)")
            }
        }
    }
    
    private func restoreBlockedApps() {
        let fileManager = FileManager.default
        
        for (_, originalPath) in renamedApps {
            let blockedPath = originalPath + ".blocked"
            
            guard fileManager.fileExists(atPath: blockedPath) else {
                continue
            }
            
            do {
                // Remove original if it exists (shouldn't happen, but just in case)
                if fileManager.fileExists(atPath: originalPath) {
                    try fileManager.removeItem(atPath: originalPath)
                }
                
                try fileManager.moveItem(atPath: blockedPath, toPath: originalPath)
                NSLog("🔓 Restored app from: \(originalPath)")
            } catch {
                NSLog("❌ Failed to restore app: \(error)")
            }
        }
        
        renamedApps.removeAll()
    }
    
    private func restoreAnyBlockedApps() {
        let fileManager = FileManager.default
        
        // Scan for any .blocked apps and restore them
        for app in config.blockedApps {
            guard let appPath = getAppPath(bundleId: app.bundleId) else {
                // App not found, check if it's in blocked state
                let possiblePaths = [
                    "/Applications/\(app.name).app",
                    "/System/Applications/\(app.name).app"
                ]
                
                for originalPath in possiblePaths {
                    let blockedPath = originalPath + ".blocked"
                    
                    if fileManager.fileExists(atPath: blockedPath) {
                        do {
                            try fileManager.moveItem(atPath: blockedPath, toPath: originalPath)
                            NSLog("🔓 Restored orphaned blocked app: \(app.name)")
                        } catch {
                            NSLog("❌ Failed to restore orphaned app \(app.name): \(error)")
                        }
                        break
                    }
                }
                continue
            }
            
            // Normal restore if found as blocked
            let blockedPath = appPath + ".blocked"
            if fileManager.fileExists(atPath: blockedPath) {
                do {
                    if fileManager.fileExists(atPath: appPath) {
                        try fileManager.removeItem(atPath: appPath)
                    }
                    try fileManager.moveItem(atPath: blockedPath, toPath: appPath)
                    NSLog("🔓 Restored app: \(app.name)")
                } catch {
                    NSLog("❌ Failed to restore app \(app.name): \(error)")
                }
            }
        }
    }
    
    private func checkSchedule() {
        let shouldBlock = isInBlockingPeriod()
        
        // State changed - entering blocking period
        if shouldBlock && !isCurrentlyBlocking {
            NSLog("🔒 Starting blocking period")
            isCurrentlyBlocking = true
            
            // Close any running blocked apps
            closeBlockedApps()
            
            // Rename apps to prevent launching
            renameBlockedApps()
            
            // Send notification
            if config.showNotifications {
                sendNotification(
                    title: "Focus Mode Started",
                    message: "Blocked apps are now unavailable until \(config.schedule.endHour):\(String(format: "%02d", config.schedule.endMinute))"
                )
            }
        }
        // State changed - exiting blocking period
        else if !shouldBlock && isCurrentlyBlocking {
            NSLog("🔓 Ending blocking period")
            isCurrentlyBlocking = false
            
            // Restore apps
            restoreBlockedApps()
            
            // Clear snooze cache
            snoozedApps.removeAll()
            
            // Send notification
            if config.showNotifications {
                sendNotification(
                    title: "Focus Mode Ended",
                    message: "Your apps are now available again"
                )
            }
        }
        // Already in blocking period - just ensure apps are closed
        else if shouldBlock && isCurrentlyBlocking {
            closeBlockedApps()
        }
    }
}

// MARK: - Main
do {
    let configPath = CommandLine.arguments.count > 1 
        ? CommandLine.arguments[1] 
        : "\(FileManager.default.homeDirectoryForCurrentUser.path)/dotfiles/focus-blocker/config.json"
    
    let blocker = try FocusBlocker(configPath: configPath)
    blocker.start()
} catch {
    NSLog("❌ Error: \(error)")
    exit(1)
}
