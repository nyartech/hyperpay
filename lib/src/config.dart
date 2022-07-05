// Copyright 2022 NyarTech LLC. All rights reserved.
// Use of this source code is governed by a BSD-style license
// that can be found in the LICENSE file.

part of hyperpay;

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
  String? applePayEntityID;
  late Uri checkoutEndpoint;
  late Uri statusEndpoint;
  PaymentMode paymentMode = PaymentMode.none;
}
