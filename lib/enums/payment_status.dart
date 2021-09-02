export 'package:hyperpay/extensions/payment_status_ext.dart';

/// Any transaction would have 3 possible group states.
///
/// See [PaymentStatusFromRegExp]
enum PaymentStatus {
  init,

  successful,

  pending,

  rejected,
}
