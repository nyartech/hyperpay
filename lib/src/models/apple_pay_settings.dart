// Copyright 2022 NyarTech LLC. All rights reserved.
// Use of this source code is governed by a BSD-style license
// that can be found in the LICENSE file.

part of hyperpay;

/// Required fields for performing a transaction with Apply Pay.
class ApplePaySettings {
  final String appleMerchantId;
  final double amount;
  final String currencyCode;
  final String countryCode;

  const ApplePaySettings({
    required this.appleMerchantId,
    required this.amount,
    required this.currencyCode,
    required this.countryCode,
  });

  Map<String, dynamic> toJson() {
    return {
      'appleMerchantId': appleMerchantId,
      'amount': amount,
      'currencyCode': currencyCode,
      'countryCode': countryCode,
    };
  }
}
