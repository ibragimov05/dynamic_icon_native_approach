import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let iconMethodChannel = FlutterMethodChannel(name: "com.example.dynamic_icon_native_approach/AppIconManager", binaryMessenger: controller.binaryMessenger)

    iconMethodChannel.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      if call.method == "switchAppIcon" {
        guard let args = call.arguments as? [String: Any] else {
          result(FlutterError(code: "INVALID_ARGS", message: "Invalid arguments", details: nil))
          return
        }

        let iconName = args["iconName"] as? String

        UIApplication.shared.setAlternateIconName(iconName) { error in
          if let error = error {
            print("Error setting alternate icon: \(error.localizedDescription)")
            result(FlutterError(code: "ICON_CHANGE_FAILED", message: error.localizedDescription, details: nil))
          } else {
            result(true)
          }
        }
      } else {
        result(FlutterMethodNotImplemented)
      }
    })

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
