// Copyright 2022 NyarTech LLC. All rights reserved.
// Use of this source code is governed by a BSD-style license
// that can be found in the LICENSE file.

part of hyperpay;

/// A handy util to turn mode enums into their corresponding
/// HyperPay string representation.
extension PaymentModeExtension on PaymentMode {
  String get string {
    switch (this) {
      case PaymentMode.live:
        return 'LIVE';
      case PaymentMode.test:
        return 'TEST';
      default:
        return '';
    }
  }
}
