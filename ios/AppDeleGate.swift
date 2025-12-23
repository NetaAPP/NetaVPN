import UIKit
import Flutter
import NetworkExtension

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    let controller = window?.rootViewController as! FlutterViewController
    let channel = FlutterMethodChannel(
      name: "netavpn/ipsec",
      binaryMessenger: controller.binaryMessenger
    )

    channel.setMethodCallHandler { call, result in
      if call.method == "connect" {
        let args = call.arguments as! [String: String]
        self.connectIPSec(
          server: args["server"]!,
          user: args["username"]!,
          pass: args["password"]!,
          psk: args["psk"]!
        )
        result(nil)
      } else if call.method == "disconnect" {
        NEVPNManager.shared().connection.stopVPNTunnel()
        result(nil)
      }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
