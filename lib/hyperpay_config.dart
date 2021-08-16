import 'package:hyperpay/enums/payment_mode.dart';

/// Payments can happen either on **Test** or **Live** mode,
/// each mode has a different set of entity IDs, these are
/// provided by HyperPay along with your merchant account.
///
/// You have to implement this class as an interface to define
/// both environment with its properties.
///
/// ```dart
/// class TestConfig implements HyperpayConfig {
///   PaymentMode paymentMode = PaymentMode.test;
///   String? creditcardEntityID = 'PASTE CREDIT CARD ENTITY ID';
///   String? madaEntityID = 'PASTE MADA ENTITY ID';
///}
/// ```
class HyperpayConfig {
  String? creditcardEntityID;
  String? madaEntityID;
  PaymentMode paymentMode = PaymentMode.none;
}
