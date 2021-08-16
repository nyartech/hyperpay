export 'package:hyperpay/extensions/payment_mode_ext.dart';

/// The environment mode for HyperPay, will be global
/// for the current life of the app.
///
/// It's recommended to change the mode according to
/// your app flavor.
///
enum PaymentMode {
  /// Use the test mode in your development environment.
  test,

  /// Use the test mode in your production environment.
  live,

  none,
}
