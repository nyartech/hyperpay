/**
 * Copyright 2022 NyarTech LLC. All rights reserved.
 *
 * Use of this source code is governed by a BSD-style license
 * that can be found in the LICENSE.
 */

import Flutter
import UIKit
import SafariServices

/// Handle calls from the Flutter side.
///
/// Currently supported brands: VISA, MastrCard, MADA, and Apple Pay.
public class SwiftHyperpayPlugin: UINavigationController, FlutterPlugin, SFSafariViewControllerDelegate, UIAdaptivePresentationControllerDelegate, PKPaymentAuthorizationViewControllerDelegate, OPPThreeDSEventListener, UINavigationControllerDelegate {
    
    var provider:OPPPaymentProvider = OPPPaymentProvider(mode: OPPProviderMode.test)
    var brand:Brand = Brand.UNKNOWN
    
    var checkoutID:String = ""
    var cardHolder:String = ""
    var cardNumber:String = ""
    var expiryMonth:String = ""
    var expiryYear:String = ""
    var cvv:String = ""
    
    /// Apple pay specific args.
    var countryCode:String = ""
    var currencyCode:String = ""
    var appleMerchantId:String = ""
    var label:String = ""
    var amount:Double = 0.0
    
    var transaction:OPPTransaction?
    var paymentResult: FlutterResult?
    var safariVC:SFSafariViewController?
    
    /// The URL that redirects the user back to the application after authroization is complete.
    var shopperResultURL:String = ""
    
    /// The payment mode could either be `TEST` or `LIVE`.
    var paymentMode:String = ""
    
    /// A suffix added to the bundle ID of the client's app to form a complete `shopperResultURL`.
    let shopperResultURLSuffix = ".payments://result";
    
    public func onThreeDSChallengeRequired(completion: @escaping (UINavigationController) -> Void) {
        let rootViewController = UIApplication.shared.delegate?.window??.rootViewController as! UINavigationController

        let nc = UINavigationController()
        nc.delegate = self
        
        DispatchQueue.main.async {
            rootViewController.present(nc, animated: true) {
                completion(nc)
            }
        }
    }
    
    public func onThreeDSConfigRequired(completion: @escaping (OPPThreeDSConfig) -> Void) {
        let config = OPPThreeDSConfig()
        config.appBundleID = Bundle.main.bundleIdentifier!
        completion(config)
    }
    
    public func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion: nil)
        self.paymentResult!("canceled")
    }
    
    public func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {
        
        if let params = try? OPPApplePayPaymentParams(checkoutID: self.checkoutID, tokenData: payment.token.paymentData) as OPPApplePayPaymentParams? {
            
            // Add the shopperResultURL to the params, without it the payment
            // can not proceed.
            params.shopperResultURL = Bundle.main.bundleIdentifier! + shopperResultURLSuffix
            
            self.provider.submitTransaction(OPPTransaction(paymentParams: params), completionHandler: { (transaction, error) in
                if (error != nil) {
                    completion(.failure)
                    self.paymentResult?(error?.localizedDescription)
                } else {
                    completion(.success)
                    self.paymentResult?("success")
                }
            })
        }
    }
    
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "plugins.nyartech.com/hyperpay", binaryMessenger: registrar.messenger())
        let instance = SwiftHyperpayPlugin()
        let buttonFactory = ApplePayButtonViewFactory(messenger: registrar.messenger())

        if let delegate = UIApplication.shared.connectedScenes.flatMap { ($0 as? UIWindowScene)?.windows ?? [] }.first { $0.isKeyWindow }  {

            let controller = FlutterViewController(project: nil, nibName: nil, bundle: nil)

            let navigationController = UINavigationController(rootViewController: controller!)


            delegate.window?.rootViewController?.view.removeFromSuperview()
            delegate.window?.rootViewController = navigationController

            navigationController.setNavigationBarHidden(true, animated: false)
        
             delegate.window?.makeKeyAndVisible()
    
        }
        
        registrar.register(buttonFactory, withId: "plugins.nyartech.com/hyperpay/apple_pay_button")
        registrar.addMethodCallDelegate(instance, channel: channel)
        registrar.addApplicationDelegate(instance)
    }
    
    public func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        var handler:Bool = false
        
        // Compare the recieved URL with our URL type
        if url.scheme!.caseInsensitiveCompare(Bundle.main.bundleIdentifier! + ".payments") == .orderedSame {
            self.didReceiveAsynchronousPaymentCallback(result: self.paymentResult!)
            
            handler = true
        }
        
        return handler
    }
    
    public func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        self.paymentResult!("canceled")
    }
    
    public func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        self.paymentResult!("canceled")
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        self.paymentResult = result
        
        if(call.method == "setup_service") {
            
            let args = call.arguments as! Dictionary<String, Any>
            paymentMode = args["mode"] as! String
            
            if(paymentMode == "LIVE") {
                self.provider.mode = OPPProviderMode.live
            } else {
                let visaSchemeConfig = OPPThreeDSSchemeConfig(dsRefId: "TEST_VISA_DS_ID",
                                                              dsEncryptCert: DS_ENCRYPT_CERT,
                                                              dsCaRootCert: DS_ROOT_CA_CERT)
                
                OPPThreeDSService.sharedInstance.setCustomSchemeConfig(["VISA": visaSchemeConfig])

                let paymentBrands = ["VISA"]
                
                OPPThreeDSService.sharedInstance.initialize(transactionMode: .test, paymentBrands: paymentBrands)
            }

            self.provider.threeDSEventListener = self
            
            NSLog("Payment mode is set to \(paymentMode)")
            
            result(nil)
            
        } else if (call.method == "start_payment_transaction") {
            
            let args = call.arguments as! Dictionary<String, Any>
            
            let checkoutID = args["checkoutID"] as! String
            self.checkoutID = checkoutID
            
            
            let brand = args["brand"] as! String
            self.brand = Brand.init(rawValue: brand) ?? Brand.UNKNOWN
            
            switch self.brand {
            case Brand.UNKNOWN:
                result(
                    FlutterError(
                        code: "0.1",
                        message: "Please provide a valid brand",
                        details: ""
                    )
                )
                
                return
            case Brand.APPLEPAY:
                onApplePay(args: args)
            default:
                // Default goes for credit cards (VISA, MADA and MasterCard)
                onCreditCard(args: args)
            }
            
        } else {
            result(
                FlutterError(code: "", message: "Method not implemented", details: "Method name: \(call.method) not implemented")
            )
        }
    }
    
    private func onCreditCard(args:Dictionary<String, Any>) {
        // Collecting card details coming from the platform channel arguments
        let card = (args["card"] as? Dictionary<String, Any>) ?? Dictionary()
        self.cardHolder = card["holder"] as! String
        self.cardNumber = card["number"] as! String
        self.expiryMonth = card["expiryMonth"] as! String
        self.expiryYear = card["expiryYear"] as! String
        self.cvv = card["cvv"] as! String
        
        // Check if credit card params are valid
        checkCreditCardValid(result: self.paymentResult!)
        
        // If all are valid, start a transaction
        do {
            let params = try OPPCardPaymentParams(
                checkoutID: self.checkoutID,
                paymentBrand: self.brand.rawValue,
                holder: self.cardHolder,
                number: self.cardNumber,
                expiryMonth: self.expiryMonth,
                expiryYear: self.expiryYear,
                cvv: self.cvv
            )
            
            params.shopperResultURL = Bundle.main.bundleIdentifier! + shopperResultURLSuffix
            
            self.transaction  = OPPTransaction(paymentParams: params)
            self.provider.submitTransaction(self.transaction!) {
                (transaction, error) in
                guard let transaction = self.transaction else {
                    self.paymentResult!(
                        FlutterError(
                            code: "0.2",
                            message: error?.localizedDescription,
                            details: ""
                        )
                    )
                    
                    return
                }
                                
                // The code 6000 is for when the user abort the process by pressing "Cancel".
                if(error != nil) {
                    let errorCode = (error! as NSError).code
                    if(errorCode == 6000){
                        UIApplication.shared.delegate?.window??.rootViewController?.dismiss(animated: true)
                        self.paymentResult!("canceled")
                    } else {
                        self.paymentResult!(
                            FlutterError(
                                code: "0.2",
                                message: error?.localizedDescription,
                                details: ""
                            )
                        )
                    }
                } else {
                    // Redirect from the 3DSecure page
                    if (transaction.threeDS2Info != nil)
                    {
                        UIApplication.shared.delegate?.window??.rootViewController?.dismiss(animated: true)
                        self.paymentResult!("success")
                    }
                    
                    if transaction.type == .asynchronous {
                        
                        self.safariVC = SFSafariViewController(url: self.transaction!.redirectURL!)
                        self.safariVC?.delegate = self;
                        UIApplication.shared.windows.first?.rootViewController!.present(self.safariVC!, animated: true, completion: nil)
                        
                    } else if transaction.type == .synchronous {
                        // Send request to your server to obtain transaction status.
                        self.paymentResult!("synchronous")
                    } else {
                        // Handle the error
                        self.paymentResult!(
                            FlutterError(
                                code: "0.2",
                                message: error?.localizedDescription,
                                details: ""
                            )
                        )
                    }
                }
            }
            
        } catch {
            self.paymentResult!(
                FlutterError(
                    code: "0.2",
                    message: error.localizedDescription,
                    details: ""
                )
            )
        }
    }
    
    private func onApplePay(args:Dictionary<String, Any>) {
        self.appleMerchantId = args["appleMerchantId"] as! String
        self.countryCode = args["countryCode"] as! String
        self.currencyCode = args["currencyCode"] as! String
        self.amount = args["amount"] as! Double
        
        let paymentRequest = OPPPaymentProvider.paymentRequest(
            withMerchantIdentifier: self.appleMerchantId,
            countryCode: self.countryCode)
        
        paymentRequest.currencyCode = self.currencyCode
        
        paymentRequest.paymentSummaryItems = [
            PKPaymentSummaryItem(label: "Hyperpay",
                                 amount: NSDecimalNumber(value: self.amount))
        ]
        
        if OPPPaymentProvider.canSubmitPaymentRequest(paymentRequest) {
            if let vc = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest) as PKPaymentAuthorizationViewController? {
                vc.delegate = self
                UIApplication.shared.windows.first?.rootViewController?.present(vc, animated: true, completion: nil)
            } else {
                NSLog("Apple Pay not supported.");
            }
        }
    }
    
    @objc func didReceiveAsynchronousPaymentCallback(result: @escaping FlutterResult) {
        NotificationCenter.default.removeObserver(
            self,
            name: Notification.Name(rawValue: "AsyncPaymentCompletedNotificationKey"),
            object: nil
        )
        
        self.safariVC?.dismiss(animated: true) {
            DispatchQueue.main.async {
                result("success")
            }
        }
        
    }
    
    /// This function checks the provided card params and return a PlatformException to Flutter if any are not valid.
    private func checkCreditCardValid(result: @escaping FlutterResult) {
        if !OPPCardPaymentParams.isNumberValid(self.cardNumber, luhnCheck: true) {
            result(
                FlutterError(
                    code: "1.1",
                    message: "Card number is not valid for brand \(self.brand)",
                    details: ""
                )
            )
        }
        else if !OPPCardPaymentParams.isHolderValid(self.cardHolder) {
            result(
                FlutterError(
                    code: "1.2",
                    message: "Holder name is not valid",
                    details: ""
                )
            )
        }
        else if !OPPCardPaymentParams.isExpiryMonthValid(self.expiryMonth) {
            result(
                FlutterError(
                    code: "1.3",
                    message: "Expiry month is not valid",
                    details: "The month should be in MM format"
                )
            )
        }
        else if !OPPCardPaymentParams.isExpiryYearValid(self.expiryYear) {
            result(
                FlutterError(
                    code: "1.4",
                    message: "Expiry year is not valid",
                    details: ""
                )
            )
        }
        else if !OPPCardPaymentParams.isCvvValid(self.cvv) {
            result(
                FlutterError(
                    code: "1.5",
                    message: "CVV is not valid",
                    details: ""
                )
            )
        }
    }
    
}

