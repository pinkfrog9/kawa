import Cocoa
import ServiceManagement

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
  let statusBar = StatusBar.shared

  var justLaunched: Bool = true

  func applicationDidFinishLaunching(_ aNotification: Notification) {
    if PermanentStorage.launchedForTheFirstTime {
      PermanentStorage.launchedForTheFirstTime = false
      registerLoginItem(enabled: PermanentStorage.launchAtLogin)
    }
  }

  private func registerLoginItem(enabled: Bool) {
    if #available(macOS 13.0, *) {
      do {
        if enabled {
          try SMAppService.mainApp.register()
        } else {
          try SMAppService.mainApp.unregister()
        }
      } catch {
        NSLog("Failed to \(enabled ? "enable" : "disable") launch at login: \(error)")
      }
    } else {
      SMLoginItemSetEnabled("com.utatti.kawa" as CFString, enabled)
    }
  }

  func applicationDidBecomeActive(_ notification: Notification) {
    if !justLaunched || PermanentStorage.launchedForTheFirstTime {
      showPreferences()
    }

    if justLaunched {
      justLaunched = false
    }
  }

  @IBAction func showPreferences(_ sender: AnyObject? = nil) {
    MainWindowController.shared.showAndActivate(self)
  }

  @IBAction func hidePreferences(_ sender: AnyObject?) {
    MainWindowController.shared.close()
  }
}
