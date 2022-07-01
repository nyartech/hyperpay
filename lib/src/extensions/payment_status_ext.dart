// Copyright 2022 NyarTech LLC. All rights reserved.
// Use of this source code is governed by a BSD-style license
// that can be found in the LICENSE file.

part of hyperpay;

/// Uses Regular Expressions to define the group
/// of a transaction result code.
///
/// Refer to [API Result Codes](https://wordpresshyperpay.docs.oppwa.com/reference/resultCodes)
/// for more information on what each group includes.
extension PaymentStatusFromRegExp on String {
  PaymentStatus get paymentStatus {
    final successRegExp = RegExp(
        r"^(000\.000\.|000\.100\.1|000\.[36]|000\.400\.0[^3]|000\.400\.[0-1]{2}0)");
    final pendingRegExp = RegExp(r"^(000\.200|800\.400\.5|100\.400\.500)");

    if (successRegExp.hasMatch(this)) {
      return PaymentStatus.successful;
    } else if (pendingRegExp.hasMatch(this)) {
      return PaymentStatus.pending;
    } else {
      return PaymentStatus.rejected;
    }
  }
}
