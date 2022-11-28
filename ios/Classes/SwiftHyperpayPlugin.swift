/**
 * Copyright 2022 NyarTech LLC. All rights reserved.
 *
 * Use of this source code is governed by a BSD-style license
 * that can be found in the LICENSE.
 */

import Flutter
import UIKit
import SafariServices
import PassKit

/// Handle calls from the Flutter side.
///
/// Currently supported brands: VISA, MastrCard, MADA, and Apple Pay.
public class SwiftHyperpayPlugin: NSObject, FlutterPlugin, SFSafariViewControllerDelegate, UIAdaptivePresentationControllerDelegate, PKPaymentAuthorizationViewControllerDelegate, OPPThreeDSEventListener {
    
    var provider : OPPPaymentProvider = OPPPaymentProvider(mode: OPPProviderMode.test)
    var brand:Brand = Brand.UNKNOWN
    
    
    let checkoutSettings = OPPCheckoutSettings()
    
    
    var CheckOutId:String = ""
    var CheckOutBookingID:String = ""
    var paymentType:String = ""
    var isfromWallet = false
    var addAmount = ""
    var paymentGetwayType:String = ""
    
    
    
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
    
//    public func onThreeDSChallengeRequired(completion: @escaping (UINavigationController) -> Void) {
//        if(self.safariVC?.navigationController != nil){
//            completion((self.safariVC?.navigationController)!)
//        }
//    }
//
//    public func onThreeDSConfigRequired(completion: @escaping (OPPThreeDSConfig) -> Void) {
//        let config = OPPThreeDSConfig()
//        completion(config)
//    }
    
    
    // code give by hyper pay developer
//    public func onThreeDSChallengeRequired(completion: @escaping (UINavigationController) -> Void) {
//        // completion(self.navigationController!)
//        if(self.safariVC?.navigationController != nil){
//            completion((self.safariVC?.navigationController)!)
//        }
//    }
    
    
    
    public func onThreeDSChallengeRequired(completion: @escaping (UINavigationController) -> Void) {
                    completion((self.safariVC?.navigationController)!)
       }
    
    public func onThreeDSConfigRequired(completion: @escaping (OPPThreeDSConfig) -> Void) {
           let config = OPPThreeDSConfig()
           config.appBundleID = Bundle.main.bundleIdentifier!
           completion(config)
       }
    // -----------------
    
    public func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion: nil)
        self.paymentResult!("canceled")
    }
    
    public func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {
        print(#function)
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
        print(#function)
        
        if(call.method == "setup_service") {

            NSLog("\(#function) setup_service")

            let args = call.arguments as! Dictionary<String, Any>
            paymentMode = args["mode"] as! String
            
            if(paymentMode == "LIVE") {
                self.provider.mode = OPPProviderMode.live
            }
            
            self.provider.threeDSEventListener = self
            
            NSLog("Payment mode is set to \(paymentMode)")
            
            result(nil)
            
        } else if (call.method == "start_payment_transaction") {

            NSLog("\(#function) else start_payment_transaction")
            
            let args = call.arguments as! Dictionary<String, Any>
            
            let checkoutID = args["checkoutID"] as! String
            self.checkoutID = checkoutID
                                     NSLog("\(#function) else $checkoutID")

            
            let brand = args["brand"] as! String
            self.brand = Brand.init(rawValue: brand) ?? Brand.UNKNOWN
            
      
            let checkoutProvider = OPPCheckoutProvider(paymentProvider: self.provider, checkoutID: self.checkoutID, settings: self.checkoutSettings)
             
            onCreditCard(args: args)
             // Since version 2.13.0
//             checkoutProvider?.presentCheckout(forSubmittingTransactionCompletionHandler: { (transaction, error) in
//                 guard let transaction = transaction else {
//                     // Handle invalid transaction, check error
//                     return
//                 }
//
//                 if transaction.type == .synchronous {
//                     // If a transaction is synchronous, just request the payment status
//                     // You can use transaction.resourcePath or just checkout ID to do it
//                 } else if transaction.type == .asynchronous {
//                     // The SDK opens transaction.redirectUrl in a browser
//                     // See 'Asynchronous Payments' guide for more details
//                 } else {
//                     // Executed in case of failure of the transaction for any reason
//                 }
//             }, cancelHandler: {
//                 // Executed if the shopper closes the payment page prematurely
//             })
//            result(
//                FlutterError(code: "", message: "Method not implemented", details: "Method name: \(call.method) not implemented")
//            )
//
        
            
            switch self.brand {
            case Brand.UNKNOWN:
                         NSLog("\(#function) else UNKNOWN")

                result(
                    FlutterError(
                        code: "0.1",
                        message: "Please provide a valid brand",
                        details: ""
                    )
                )
                
                return
            case Brand.APPLEPAY:
                         NSLog("\(#function) else apple pay")

                onApplePay(args: args)
            default:
             NSLog("\(#function) else default")
                // Default goes for credit cards (VISA, MADA and MasterCard)
//                onCreditCard(args: args)
                
            }
            
        } else {
        NSLog("\(#function) else start_payment_transaction")
            result(
                FlutterError(code: "", message: "Method not implemented", details: "Method name: \(call.method) not implemented")
            )
        }
    }
    
    private func onCreditCard(args:Dictionary<String, Any>) {
   
        NSLog("\(#function) On Credit Card ")
    
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
     
            NSLog("shopperResultURL error \(params.shopperResultURL)")
     
            self.transaction  = OPPTransaction(paymentParams: params)
            
            self.provider.submitTransaction(self.transaction!) {
                (transaction, error) in
              
                NSLog("transaction error \(transaction.type)")
                NSLog("transaction redirectURL error \(transaction.redirectURL!)")
                NSLog("error error \(error)")
                
                guard let transaction = self.transaction else {
                    self.paymentResult!(
                        FlutterError(
                            code: "0.2",
                            message: error!.localizedDescription,
                            details: ""
                        )
                    )
                    
                    return
                }
                
                if transaction.type == .asynchronous {
                    
                    self.safariVC = SFSafariViewController(url: self.transaction!.redirectURL!)
                    self.safariVC?.delegate = self;
                    UIApplication.shared.windows.first?.rootViewController!.present(self.safariVC!, animated: true, completion: nil)
                    NSLog("transaction asynchronous \(transaction.type)")
                } else {
                    NSLog("transaction error else")
                    // Executed in case of failure of the transaction for any reason
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
            
        } catch {
            
            NSLog("transaction error catch")
            
            
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
                
                // TODO: send notification to request payment status
            }
        }
        
    }
    
    /// This function checks the provided card params and return a PlatformException to Flutter if any are not valid.
    ///
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
    
    
    func checkoutProvider(_ checkoutProvider: OPPCheckoutProvider, continueSubmitting transaction: OPPTransaction, completion: @escaping (String?, Bool) -> Void) {
           // To continue submitting you should call completion block which expects 2 parameters:
           // checkoutID - you can create new checkoutID here or pass current one
           // abort - you can abort transaction here by passing 'true'
           //        print(#function)
           //        print(transaction.paymentParams.checkoutID)
           completion(transaction.paymentParams.checkoutID,false)
       }
       
       func checkoutProvider(_ checkoutProvider: OPPCheckoutProvider, validateCardHolder cardHolder: String?) -> Bool {
           return (cardHolder!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count > 0)
       }
//
//    func OpenPaymentPage(CheckOutID:String, BookingID: String, Type: String, Payment_type: String, amount:String, iswallet:Bool, isApplePay : Bool = false) {
////         Utilities.hideHud()
//         //checkoutSettings.paymentBrands = ["VISA", "MASTER"]
//         checkoutSettings.paymentBrands = [Type]//arrCardsTypes
//         checkoutSettings.shopperResultURL = "com.eww.BeatPatient.payments://result"
//
//         checkoutSettings.theme.cancelBarButtonText = "Cancel".Localized()
//
//
//         //SJ_Comment : Hyperpay Language. If urdu then Apply arabic language.
//         if let selectedLanguage = (UserDefaults.standard.value(forKey: "language") as? String) {
//
//             switch selectedLanguage {
//
//             case "en":
//                 checkoutSettings.language = selectedLanguage
//             case "ar":
//                 checkoutSettings.language = selectedLanguage
//             case "ur":
//                 checkoutSettings.language = "ar"
//             default:
//                 checkoutSettings.language = "ar"
//                 break
//             }
//         }
//
//
//
//         Chkprovider = OPPCheckoutProvider(paymentProvider: provider, checkoutID: CheckOutID, settings: checkoutSettings)!
//         Chkprovider.delegate = self
//         if(isApplePay)
//         {
//
//             let paymentRequest = OPPPaymentProvider.paymentRequest(withMerchantIdentifier: "merchant.com.eww.BeatPatient", countryCode: "SA")
//             paymentRequest.supportedNetworks = supportedNetworks
//             paymentRequest.paymentSummaryItems = [PKPaymentSummaryItem(label: AppName, amount: (Double(amount) as? NSDecimalNumber ?? 0.0))]
// //            checkoutSettings.paymentTitle = "Mainzilia"
//             checkoutSettings.applePayPaymentRequest = paymentRequest
//             let checkoutProvider = OPPCheckoutProvider(paymentProvider: provider, checkoutID: CheckOutID, settings: checkoutSettings)
//             checkoutProvider?.presentCheckout(withPaymentBrand: "APPLEPAY") { inProgress in
//                 // Executed whenever SDK sends request to the server or receives the answer.
//                 // You can start or stop loading animation based on inProgress parameter.
//                 print("The progress is \(inProgress)")
//
//                 if(inProgress)
//                 {
//                     Utilities.showHud()
//                 }
//                 else
//                 {
//                     Utilities.hideHud()
//                 }
//
//             } completionHandler: { transaction, error in
//                 if error != nil {
// //                    print("The error is Apple pay is \(error?.localizedDescription ?? "-------")")
//
//                     let message = """
//                     There is no card in Apple pay.
//
//                     To add a new card on your iPhone
//                     1. In the Wallet app, tap the Add button.
//                     2. Tap Debit or Credit Card.
//                     3. Tap Continue.
//                     4. Follow the steps on the screen to add a new card. If prompted, choose your bank or card issuer from the list or find them using the search bar.
//                     5. Verify your information with your bank or card issuer. They may ask you to provide additional information or to download an app before approving your card for use with Apple Pay.
//                     6. If you have a paired Apple Watch, you have the option to also add the card to your watch.
//                     """
//                     if(error?.localizedDescription == "Payment method is not available.")
//                     {
//                         Utilities.displayErrorAlert(message)
//                     }
//                     else
//                     {
//                         Utilities.displayErrorAlert(error?.localizedDescription ?? "Apple pay not supported")
//                     }
//                 } else {
//                     if transaction?.redirectURL != nil {
//                         // Shopper was redirected to the issuer web page.
//                         // Request payment status when shopper returns to the app using transaction.resourcePath or just checkout id.
//                         //                            print("The transaction url is \(transaction?.redirectURL! ?? "")")
//                     } else {
//                         self.checkPaymentStatus()
//                         print("Request payment status for the synchronous transaction from your server using transactionPath.resourcePath or just checkout id.")
//                         // Request payment status for the synchronous transaction from your server using transactionPath.resourcePath or just checkout id.
//                     }
//                 }
//             } cancelHandler: {
//                 // Executed if the shopper closes the payment page prematurely.
//                 print("Cancel")
//             }
//
//         }
//         else
//         {
//
//             provider.presentCheckout(forSubmittingTransactionCompletionHandler: { (transaction, error) in
//                 guard let transaction = transaction else {
//                     return
//                 }
//                 if transaction.type == .synchronous {
//                     // If a transaction is synchronous, just request the payment status
//                     // You can use transaction.resourcePath or just checkout ID to do it
//                     self.checkPaymentStatus()
//                 } else if transaction.type == .asynchronous {
//                     // The SDK opens transaction.redirectUrl in a browser
//                     // See 'Asynchronous Payments' guide for more details
//                     //self.checkPaymentStatus()
//                 } else {
//                     // Executed in case of failure of the transaction for any reason
//                 }
//
//             }, cancelHandler: {
//                 // Executed if the shopper closes the payment page prematurely
//
//             })
//         }
//
//     }
    
}

