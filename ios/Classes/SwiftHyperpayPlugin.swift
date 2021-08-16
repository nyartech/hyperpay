import Flutter
import UIKit
import SafariServices

/// Handle the call from channel `hyperpay`
///
/// Currently supported brands: *VISA, MASTERCARD, MADA*
public class SwiftHyperpayPlugin: FlutterAppDelegate, FlutterPlugin, SFSafariViewControllerDelegate {
    var checkoutID:String = "";
    var provider:OPPPaymentProvider = OPPPaymentProvider(mode: OPPProviderMode.test)
    var brand:Brand = Brand.UNKNOWN;
    
    var cardHolder:String = "";
    var cardNumber:String = "";
    var expiryMonth:String = "";
    var expiryYear:String = "";
    var cvv:String = "";
    
    var transaction:OPPTransaction?;
    var paymentResult: FlutterResult?;
    var safariVC:SFSafariViewController?;
    var shopperResultURL:String = "";
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "hyperpay", binaryMessenger: registrar.messenger())
        let instance = SwiftHyperpayPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        registrar.addApplicationDelegate(instance)
    }
    

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        
        self.paymentResult = result
        
        let args = call.arguments as! Dictionary<String, Any>
        
        let checkoutID = args["checkoutID"] as! String
        self.checkoutID = checkoutID
        
        let mode = args["mode"] as! String
        let brand = args["brand"] as! String
        self.brand = Brand.init(rawValue: brand) ?? Brand.UNKNOWN
        
        // Collecting card details coming from the platform channel arguments
        let card = args["card"] as! Dictionary<String, Any>
        self.cardHolder = card["holder"] as! String
        self.cardNumber = card["number"] as! String
        self.expiryMonth = card["expiryMonth"] as! String
        self.expiryYear = card["expiryYear"] as! String
        self.cvv = card["cvv"] as! String
        
        if(mode == "LIVE") {
            self.provider.mode = OPPProviderMode.test
        }
        
        switch self.brand {
            case Brand.UNKNOWN:
                result(
                    FlutterError(
                        code: "0.1",
                        message: "Please provide a valid brand",
                        details: ""
                    )
                )
            // Default goes for credit cards (VISA, MADA and MasterCard)
            default:
                // Check if credit card params are valid
                checkCreditCardValid(result: result)
                
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
                    
                    params.shopperResultURL = Bundle.main.bundleIdentifier! + ".payments://result"
                    
                    self.transaction  = OPPTransaction(paymentParams: params)
                    self.provider.submitTransaction(self.transaction!) {
                        (transaction, error) in
                        guard let transaction = self.transaction else {
                            result(
                                FlutterError(
                                    code: "0.3",
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
                                                        
                        } else if transaction.type == .synchronous {
                            // Send request to your server to obtain transaction status
                            result("Success: synchronous 🎉")
                        } else {
                            // Handle the error
                            result("Error ☹️")
                        }
                    }
                    
                } catch {
                    result(
                        FlutterError(
                            code: "0.2",
                            message: error.localizedDescription,
                            details: ""
                        )
                    )
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
                result("Success: asynchronous 🎉")
                
                // TODO: send notification to request payment status
            }
        }
        
    }
    
    public override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        var handler:Bool = false
                                
        // Compare the recieved URL with our URL type
        if url.scheme!.caseInsensitiveCompare(Bundle.main.bundleIdentifier! + ".payments") == .orderedSame {

            self.didReceiveAsynchronousPaymentCallback(result: self.paymentResult!)

            handler = true
        }

        return handler
    }
    
 
    /// This function checks the provided card params and return a PlatformException to Flutter if any are not valid.
    ///
    /// **Error Codes**:
    /// `1.1`: invalid card number
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

