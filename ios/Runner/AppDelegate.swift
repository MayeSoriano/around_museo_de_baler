import Flutter
import UIKit
import Firebase

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure() // Initializes Firebase
    GeneratedPluginRegistrant.register(with: self) // Registers plugins
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
