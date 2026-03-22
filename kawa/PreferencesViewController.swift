import Cocoa
import ServiceManagement

class PreferencesViewController: NSViewController {
  @IBOutlet weak var showNotificationCheckbox: NSButton!
  @IBOutlet weak var hideMenuBarIconCheckbox: NSButton!
  @IBOutlet weak var launchAtLoginCheckbox: NSButton!

  override func viewDidLoad() {
    super.viewDidLoad()

    showNotificationCheckbox.state = PermanentStorage.showsNotification.stateValue
    hideMenuBarIconCheckbox.state = PermanentStorage.hidesMenuBarIcon.stateValue
    launchAtLoginCheckbox.state = PermanentStorage.launchAtLogin.stateValue
  }

  @IBAction func quitApp(_ sender: NSButton) {
    NSApplication.shared.terminate(nil)
  }

  @IBAction func showNotification(_ sender: NSButton) {
    PermanentStorage.showsNotification = sender.state.boolValue
  }

  @IBAction func hideMenuBarIcon(_ sender: NSButton) {
    PermanentStorage.hidesMenuBarIcon = sender.state.boolValue
    StatusBar.shared.updateVisibility()
  }

  @IBAction func launchAtLogin(_ sender: NSButton) {
    let enabled = sender.state.boolValue
    PermanentStorage.launchAtLogin = enabled
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
}

private extension Bool {
  var stateValue: NSControl.StateValue {
    return self ? .on : .off;
  }
}

private extension NSControl.StateValue {
  var boolValue: Bool {
    return self == .on;
  }
}
