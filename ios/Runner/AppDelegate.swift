import Flutter
import PassKit
import UIKit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {

  private var methodChannel: FlutterMethodChannel?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller = window?.rootViewController as! FlutterViewController
    methodChannel = FlutterMethodChannel(
      name: "REQUEST_WALLET",
      binaryMessenger: controller.binaryMessenger)

    methodChannel?.setMethodCallHandler({
      [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      guard let strongSelf = self else {
        result(FlutterError.init(code: "error", message: "AppDelegate deallocated", details: nil))
        return
      }
      if call.method == "ADD_TO_WALLET" {
        strongSelf.handleAddToWallet(call: call, result: result)
      } else {
        result(FlutterMethodNotImplemented)
      }
    })

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func handleAddToWallet(call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard let args = call.arguments as? [String: Any],
      let passUrlString = args["passUrl"] as? String,
      let passUrl = URL(string: passUrlString)
    else {
      result(
        FlutterError(code: "invalidArguments", message: "Invalid arguments received", details: nil))
      return
    }

    addPassToWallet(from: passUrl, result: result)
  }

    private func addPassToWallet(from url: URL, result: @escaping FlutterResult) {
        // Attempt to create the pass data
        guard let passData = try? Data(contentsOf: url) else {
            result(FlutterError(code: "errorLoadingData", message: "Could not load data from the given URL", details: nil))
            return
        }

        // Attempt to create the pass object
        do {
            let pass = try PKPass(data: passData)
            
            // Check if passes can be added to the Apple Wallet
            if PKAddPassesViewController.canAddPasses() {
                let addPassViewController = PKAddPassesViewController(pass: pass)
                addPassViewController?.delegate = self
                if let viewController = addPassViewController {
                    window?.rootViewController?.present(viewController, animated: true, completion: nil)
                    result(nil) // Call result with nil on success
                } else {
                    result(FlutterError(code: "errorPresenting", message: "Cannot present add pass view controller", details: nil))
                }
            } else {
                result(FlutterError(code: "cannotAddPasses", message: "This device cannot add passes to Apple Wallet", details: nil))
            }
        } catch {
            // Handle any errors that might have occurred while creating the PKPass object
            result(FlutterError(code: "errorCreatingPass", message: "Failed to create PKPass from data: \(error.localizedDescription)", details: nil))
        }
    }
}

extension AppDelegate: PKAddPassesViewControllerDelegate {
  func addPassesViewControllerDidFinish(_ controller: PKAddPassesViewController) {
    controller.dismiss(animated: true, completion: nil)
  }
}
