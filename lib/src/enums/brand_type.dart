// Copyright 2022 NyarTech LLC. All rights reserved.
// Use of this source code is governed by a BSD-style license
// that can be found in the LICENSE file.

part of hyperpay;

/// Currently supported brands by this plugin.
enum BrandType {
  visa,

  master,

  mada,

  applepay,

  /// If no brand is chosen, use none to avoid
  /// any unnecessary errors.
  none,
}
