import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart';

enum PaymentMode { test, live }
enum BrandType { visa, mastercard, mada, stcpay, applepay }

class Brand {
  BrandType type;
  String entityID;

  Brand({required this.type, required this.entityID});
}

class CheckoutSettings {
  CheckoutSettings({
    required this.brand,
    required this.host,
    required this.path,
    required this.amount,
    this.additionalParams = const {},
  });

  Brand brand;
  String host;
  String path;
  double amount;
  Map<String, dynamic> additionalParams;
}

extension on PaymentMode {
  String get string {
    switch (this) {
      case PaymentMode.live:
        return 'LIVE';
      case PaymentMode.test:
        return 'TEST';
    }
  }
}

class HyperpayPlugin {
  HyperpayPlugin({required this.mode, required this.checkoutSettings});

  final PaymentMode mode;
  final CheckoutSettings checkoutSettings;

  static const MethodChannel _channel = const MethodChannel('hyperpay');

  Future<String?> get checkoutID async {
    try {
      Uri url = Uri(
        scheme: 'https',
        host: checkoutSettings.host,
        path: checkoutSettings.path,
      );

      final Response response = await post(
        url,
        body: {
          'entityID': checkoutSettings.brand.entityID,
          'amount': checkoutSettings.amount.toStringAsFixed(2),
          'additionalParams': json.encode(checkoutSettings.additionalParams),
        },
      );

      final _resBody = json.decode(response.body);

      String _checkoutID = '';

      if (_resBody['code'] != '000.200.100') {
        _checkoutID = _resBody['id'];
      } else {
        throw Exception();
      }

      return _checkoutID;
    } catch (exception) {
      rethrow;
    }
  }
}
