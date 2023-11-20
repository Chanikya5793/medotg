import Cocoa
import FlutterMacOS

@NSApplicationMain
class AppDelegate: FlutterAppDelegate {
  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return true
  }
  override func applicationDidBecomeActive(_ notification: Notification) {
    NSApp.activate(ignoringOtherApps: true)
  }
}
