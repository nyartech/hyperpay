// Copyright 2022 NyarTech LLC. All rights reserved.
// Use of this source code is governed by a BSD-style license
// that can be found in the LICENSE file.

part of hyperpay;

/// Exception to wrap HyperPay API errors.
class HyperpayException implements Exception {
  /// A message describing the error coming from HyperPay server.
  final String message;

  /// The code of the error from HyperPay API.
  final String? code;

  /// More details about the error.
  final String? details;

  const HyperpayException([this.message = "", this.code, this.details]);

  String toString() {
    return "$code: $message, details: $details";
  }
}
