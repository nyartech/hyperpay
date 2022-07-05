// Copyright 2022 NyarTech LLC. All rights reserved.
// Use of this source code is governed by a BSD-style license
// that can be found in the LICENSE file.

part of hyperpay;

/// The environment mode for HyperPay, will be global
/// for the current life of the app.
///
/// It's recommended to change the mode according to
/// your app flavor.
///
enum PaymentMode {
  /// Use the test mode in your development environment.
  test,

  /// Use the test mode in your production environment.
  live,

  none,
}
