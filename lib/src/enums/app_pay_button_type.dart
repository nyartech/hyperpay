part of hyperpay;

/// The types of button supported on Apple Pay.
///
/// See [PKPaymentButtonType](https://developer.apple.com/documentation/passkit/pkpaymentbuttontype).
enum ApplePayButtonType {
  plain,
  buy,
  setUp,
  checkout,
  book,
  subscribe,
  reload,
  addMoney,
  topUp,
  order,
  rent,
  support,
  contribute,
  tip
}
