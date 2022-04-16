part of hyperpay;

/// Currently supported brands by this plugin.
enum BrandType {
  visa,

  mastercard,

  mada,

  applepay,

  /// If no brand is chosen, use none to avoid
  /// any unnecessary errors.
  none,
}
