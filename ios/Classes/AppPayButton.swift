/**
 * Copyright 2022 NyarTech LLC. All rights reserved.
 *
 * Use of this source code is governed by a BSD-style license
 * that can be found in the LICENSE.
 */

import Flutter
import UIKit
import PassKit

/// A factory class that creates the `FlutterPlatformView` that needs to render
/// and displayed on the Flutter end.
class ApplePayButtonViewFactory: NSObject, FlutterPlatformViewFactory {
  
  /// Holds the object needed to connect both the Flutter and native ends.
  private var messenger: FlutterBinaryMessenger
  
  /// Instantiates the class with the associated messenger.
  ///
  /// - parameter messenger: An object to help the Flutter and native ends communicate.
  init(messenger: FlutterBinaryMessenger) {
    self.messenger = messenger
    super.init()
  }
  
  /// Create a `FlutterPlatformView`.
  ///
  /// Implemented by iOS code that expose a `UIView` for embedding in a Flutter app.
  /// The implementation of this method should create a new `UIView` and return it.
  func create(
    withFrame frame: CGRect,
    viewIdentifier viewId: Int64,
    arguments args: Any?
  ) -> FlutterPlatformView {
    return ApplePayButtonView(
      frame: frame,
      viewIdentifier: viewId,
      arguments: args,
      binaryMessenger: messenger)
  }
  
  func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
    return FlutterStandardMessageCodec.sharedInstance()
  }
}

/// A class to draw Apple Pay's `PKPaymentButton` natively.
class ApplePayButtonView: NSObject, FlutterPlatformView {
  
  /// Button channel.
  static let buttonMethodChannelName = "plugins.nyartech.com/hyperpay/apple_pay_button"
  
  /// Holds the actual view with the contents to be send back to Flutter.
  private var _view: UIView
  
  /// The channel used to communicate with Flutter.
  private let channel: FlutterMethodChannel
  
  /// Handel Flutter's on tap event.
  @objc func handleApplePayButtonTapped() {
    channel.invokeMethod("onPressed", arguments: nil)
  }
  
  /// Creates a `PKPaymentButton` based on the parameters received from Flutter.
  init(
    frame: CGRect,
    viewIdentifier viewId: Int64,
    arguments args: Any?,
    binaryMessenger messenger: FlutterBinaryMessenger
  ) {
    _view = UIView()
    
    let arguments = args as! Dictionary<String, AnyObject>
    let type = arguments["type"] as! String
    let style = arguments["style"] as! String
    
    // Instantiate the channel to talk to the Flutter end.
    channel = FlutterMethodChannel(name: "\(ApplePayButtonView.buttonMethodChannelName)/\(viewId)",
                                   binaryMessenger: messenger)
    
    super.init()
    channel.setMethodCallHandler(handleFlutterCall)
    createApplePayView(type: type, style: style)
  }

  public func handleFlutterCall(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    default:
      result(FlutterMethodNotImplemented)
    }
  }
  
  func view() -> UIView {
    return _view
  }
  
  /// Creates a `PKPaymentButton` with the defined styles and constraints.
  func createApplePayView(type buttonTypeString: String, style buttonStyleString: String){
    
    // Create the PK objects
    let paymentButtonType = PKPaymentButtonType.fromString(buttonTypeString) ?? .plain
    let paymentButtonStyle = PKPaymentButtonStyle.fromString(buttonStyleString) ?? .black
    let applePayButton = PKPaymentButton(paymentButtonType: paymentButtonType, paymentButtonStyle: paymentButtonStyle)
    
    // Configure the button
    applePayButton.translatesAutoresizingMaskIntoConstraints = false
    applePayButton.addTarget(self, action: #selector(handleApplePayButtonTapped), for: .touchUpInside)
    _view.addSubview(applePayButton)
    
    // Enable constraints
    applePayButton.topAnchor.constraint(equalTo: _view.topAnchor).isActive = true
    applePayButton.bottomAnchor.constraint(equalTo: _view.bottomAnchor).isActive = true
    applePayButton.leftAnchor.constraint(equalTo: _view.leftAnchor).isActive = true
    applePayButton.rightAnchor.constraint(equalTo: _view.rightAnchor).isActive = true
  }
}

/// A set of utility methods associated to `PKPaymentButtonType`.
extension PKPaymentButtonType {
  
  /// Creates a `PKPaymentButtonType` object from a string. This string comes from Flutter.
  public static func fromString(_ buttonType: String) -> PKPaymentButtonType? {
    switch buttonType {
    case "buy":
      return .buy
    case "setUp":
      return .setUp
    case "checkout":
      guard #available(iOS 12.0, *) else { return nil }
      return .checkout
    case "book":
      guard #available(iOS 12.0, *) else { return nil }
      return .book
    case "subscribe":
      guard #available(iOS 12.0, *) else { return nil }
      return .subscribe
    default:
      guard #available(iOS 14.0, *) else { return .plain }
      switch buttonType {
      case "reload":
        return .reload
      case "addMoney":
        return .addMoney
      case "topUp":
        return .topUp
      case "order":
        return .order
      case "rent":
        return .rent
      case "support":
        return .support
      case "contribute":
        return .contribute
      case "tip":
        return .tip
      default:
        return nil
      }
    }
  }
}

/// A set of utility methods associated to `PKPaymentButtonStyle`.
extension PKPaymentButtonStyle {
  
  /// Creates a `PKPaymentButtonStyle` object from a string. This string comes from Flutter.
  public static func fromString(_ buttonStyle: String) -> PKPaymentButtonStyle? {
    switch buttonStyle {
    case "white":
      return .white
    case "whiteOutline":
      return .whiteOutline
    case "black":
      return .black
    case "automatic":
      guard #available(iOS 14.0, *) else { return nil }
      return .automatic
    default:
      return nil
    }
  }
}
