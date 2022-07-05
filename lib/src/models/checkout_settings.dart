// Copyright 2022 NyarTech LLC. All rights reserved.
// Use of this source code is governed by a BSD-style license
// that can be found in the LICENSE file.

part of hyperpay;

/// This class wraps the required params to get a `checkoutID`
/// from HyperPay **server-to-server**, meaning that these params
/// are sent later in the body of your call to get a `checkoutID`
/// to your server.
///
/// See [HyperpayPlugin]
///
class CheckoutSettings {
  CheckoutSettings({
    required this.brand,
    required this.amount,
    required this.headers,
    this.additionalParams = const {},
  });

  /// The brand has the type and entity ID of the
  /// card the user will pay with.
  BrandType brand;

  /// The amount to be paid.
  double amount;

  /// The headers of your HTTP request.
  Map<String, String> headers;

  /// HyperPay allows sending additional params
  /// to help you identify payments on your own DB.
  /// Insert them as key/valye pairs.
  ///
  /// Check [here](https://wordpresshyperpay.docs.oppwa.com/reference/parameters#customer) for full list of allowed parameters.
  Map<String, dynamic> additionalParams;

  clear() {
    brand = BrandType.none;
    amount = 0.0;
    additionalParams = {};
  }
}
