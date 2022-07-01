part of hyperpay;

/// A set of utility methods associated to the [ApplePayButtonType] enum.
extension ApplePayButtonTypeExt on ApplePayButtonType {
  /// The minimum width for this button type according to
  /// [Apple Pay's Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/apple-pay/overview/buttons-and-marks/)
  /// for the button.
  double get minimumWidth => this == ApplePayButtonType.plain ? 100 : 140;
}
