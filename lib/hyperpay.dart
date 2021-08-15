import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:http/http.dart';

import 'package:hyperpay/brands.dart';
import 'package:hyperpay/payment_mode.dart';
import 'package:hyperpay/models/checkout_settings.dart';
import 'package:hyperpay/models/payment_settings.dart';
import 'package:hyperpay/models/card_info.dart';

export 'package:hyperpay/brands.dart';
export 'package:hyperpay/formatters.dart';
export 'package:hyperpay/payment_mode.dart';
export 'package:hyperpay/models/checkout_settings.dart';
export 'package:hyperpay/models/payment_settings.dart';
export 'package:hyperpay/models/card_info.dart';

class HyperpayPlugin {
  HyperpayPlugin({
    required this.mode,
    required this.checkoutSettings,
    required this.paymentSettings,
  });

  final PaymentMode mode;
  final CheckoutSettings checkoutSettings;
  final PaymentSettings paymentSettings;

  static const MethodChannel _channel = const MethodChannel('hyperpay');

  Future<String> get getCheckoutID async {
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

      log(_checkoutID, name: "HyperpayPlugin/getCheckoutID");

      return _checkoutID;
    } catch (exception) {
      rethrow;
    }
  }

  Future<String?> pay(String checkotuID, CardInfo card) async {
    try {
      final result = await _channel.invokeMethod(
        'hyperpay',
        {
          'checkoutID': checkotuID,
          'brand': checkoutSettings.brand.type.asString,
          'mode': mode.string,
          'card': card.toMap(),
        },
      );

      print(result);

      return result;
    } catch (e) {
      log('$e');
    }
  }

  Future<String> paymentStatus(String checkoutID) async {
    try {
      Uri url = Uri(
        scheme: 'https',
        host: paymentSettings.host,
        path: paymentSettings.path,
      );

      final Response response = await post(
        url,
        body: {
          'entityId': checkoutSettings.brand.entityID,
          'checkoutId': checkoutID,
        },
      );

      final Map<String, dynamic> _resBody = json.decode(response.body);

      log(_resBody.values.join(','), name: "HyperpayPlugin/checkPaymentStatus");

      return _resBody.values.join(',');
    } catch (exception) {
      rethrow;
    }
  }
}
