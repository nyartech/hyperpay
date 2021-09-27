part of hyperpay;

/// Any transaction would have 4 possible group states.
///
/// See [PaymentStatusFromRegExp]
enum PaymentStatus {
  /// `checkoutID` is initiated and a session is in progress,
  /// if no action from the user happened, such that they never
  /// completed the payment, the checkoutID will expire.
  init,

  /// Payment session is successful, the `checkoutID` will no
  /// longer be valid after it.
  successful,

  /// Payment is done and now waiting for response from HyperPay/bank.
  pending,

  /// Payment is done but something wrong happened.
  rejected,
}
