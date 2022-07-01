// Copyright 2022 NyarTech LLC. All rights reserved.
// Use of this source code is governed by a BSD-style license
// that can be found in the LICENSE file.

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
