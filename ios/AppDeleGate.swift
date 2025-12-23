
import UIKit
import Flutter
import NetworkExtension

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {

  // MARK: - IPsec 연결 함수
  func connectIPSec(
    server: String,
    user: String,
    pass: String,
    psk: String
  ) {
    let manager = NEVPNManager.shared()

    let proto = NEVPNProtocolIPSec()
    proto.serverAddress = server
    proto.username = user

    // 비밀번호
    proto.passwordReference = pass.data(using: .utf8)

    // PSK 방식
    proto.authenticationMethod = .sharedSecret
    proto.sharedSecretReference = psk.data(using: .utf8)

    proto.useExtendedAuthentication = true
    proto.disconnectOnSleep = false

    manager.protocolConfiguration = proto
    manager.localizedDescription = "NetaVPN"
    manager.isEnabled = true

    manager.saveToPreferences { error in
      if let error = error {
        print("❌ VPN save error: \(error)")
        return
      }

      do {
        try manager.connection.startVPNTunnel()
        print("✅ VPN connecting to \(server)")
      } catch {
        print("❌ VPN start error: \(error)")
      }
    }
  }

  // MARK: - App Launch
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    let controller = window?.rootViewController as! FlutterViewController

    let channel = FlutterMethodChannel(
      name: "netavpn/ipsec",
      binaryMessenger: controller.binaryMessenger
    )

    channel.setMethodCallHandler { [weak self] call, result in
      guard let self = self else { return }

      switch call.method {

      case "connect":
        guard let args = call.arguments as? [String: String],
              let server = args["server"],
              let username = args["username"],
              let password = args["password"],
              let psk = args["psk"]
        else {
          result(FlutterError(
            code: "BAD_ARGS",
            message: "Invalid arguments",
            details: nil
          ))
          return
        }

        self.connectIPSec(
          server: server,
          user: username,
          pass: password,
          psk: psk
        )

        result(nil)

      case "disconnect":
        NEVPNManager.shared().connection.stopVPNTunnel()
        print("🛑 VPN disconnected")
        result(nil)

      default:
        result(FlutterMethodNotImplemented)
      }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
