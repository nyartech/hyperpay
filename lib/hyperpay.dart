import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart';

import 'package:hyperpay/hyperpay_config.dart';
import 'package:hyperpay/hyperpay_exception.dart';
import 'package:hyperpay/enums/payment_status.dart';
import 'package:hyperpay/enums/payment_mode.dart';
import 'package:hyperpay/enums/brand_type.dart';
import 'package:hyperpay/extensions/brands_ext.dart';
import 'package:hyperpay/models/card_info.dart';
import 'package:hyperpay/models/checkout_settings.dart';

export 'package:hyperpay/hyperpay_config.dart';
export 'package:hyperpay/hyperpay_exception.dart';
export 'package:hyperpay/extensions/brands_ext.dart';
export 'package:hyperpay/ui_utils/formatters.dart';
export 'package:hyperpay/enums/payment_mode.dart';
export 'package:hyperpay/enums/brand_type.dart';
export 'package:hyperpay/models/card_info.dart';
export 'package:hyperpay/models/checkout_settings.dart';

/// The interface for Hyperpay SDK.
/// To use this plugin, you will need to have 2 endpoints on your server.
///
/// Please check
/// [the guide to setup your server](https://wordpresshyperpay.docs.oppwa.com/tutorials/mobile-sdk/integration/server).
///
/// Refer to [HyperPay API](https://wordpresshyperpay.docs.oppwa.com/reference/parameters)
/// for more information on Test/Live systems
class HyperpayPlugin {
  HyperpayPlugin._();
  static HyperpayPlugin instance = HyperpayPlugin._();

  static const MethodChannel _channel = const MethodChannel('hyperpay');

  late HyperpayConfig _config;
  late final Uri _checkoutEndpoint;
  late final Uri _statusEndpoint;

  CheckoutSettings? _checkoutSettings;

  /// Read the configurations used to setup this instance of HyperPay.
  HyperpayConfig get config => _config;

  /// Setup HyperPay plugin with the required stuff to make a successful
  /// payment transaction.
  ///
  /// See [HyperpayConfig], [PaymentMode]
  Future<void> setup({
    required Uri checkoutEndpoint,
    required Uri statusEndpoint,
    required HyperpayConfig config,
  }) async {
    _checkoutEndpoint = checkoutEndpoint;
    _statusEndpoint = statusEndpoint;
    _config = config;

    await _channel.invokeMethod(
      'setup_service',
      {
        'mode': config.paymentMode.string,
      },
    );
  }

  /// Instantiate a checkout session.
  void initSession({required CheckoutSettings checkoutSetting}) async {
    // ensure anything from previous session is cleaned up.
    _clearSession();
    _checkoutSettings = checkoutSetting;
  }

  /// Used to clear any lefovers from previous session
  /// before starting a new one.
  void _clearSession() {
    if (_checkoutSettings != null) {
      _checkoutSettings?.clear();
    }
  }

  /// A call to the endpoint on your server to get a checkout ID.
  Future<String> get getCheckoutID async {
    try {
      final Response response = await post(
        _checkoutEndpoint,
        body: {
          'entityID': _checkoutSettings?.brand.entityID,
          'amount': _checkoutSettings?.amount.toStringAsFixed(2),
          'additionalParams': json.encode(_checkoutSettings?.additionalParams),
        },
      );

      if (response.statusCode != 200) {
        throw HttpException('Response code ${response.statusCode}');
      }

      final _resBody = json.decode(response.body);

      String _checkoutID = '';

      switch (_resBody['result']['code']) {
        case '000.200.100':
          _checkoutID = _resBody['id'];
          break;
        case '200.300.404':
          throw HyperpayException(
            _resBody['description'],
            _resBody['code'],
            _resBody['parameterErrors']
                .map(
                  (param) => '(param: ${param['name']}, value: ${param['value']})',
                )
                .join(','),
          );
        default:
          throw HyperpayException(
            _resBody['description'],
            _resBody['code'],
          );
      }

      log(_checkoutID, name: "HyperpayPlugin/getCheckoutID");

      return _checkoutID;
    } catch (exception) {
      log('${exception.toString()}', name: "HyperpayPlugin/getCheckoutID");
      rethrow;
    }
  }

  /// Perform the transaction using iOS/Android HyperPay SDK.
  ///
  /// It's highly recommended to setup a listner using
  /// [HyperPay webhooks](https://wordpresshyperpay.docs.oppwa.com/tutorials/webhooks),
  /// and perform the requird action after payment (e.g. issue receipt) on your server.
  Future<void> pay(CardInfo card) async {
    try {
      final checkoutID = await HyperpayPlugin.instance.getCheckoutID;
      final result = await _channel.invokeMethod(
        'start_payment_transaction',
        {
          'checkoutID': checkoutID,
          'brand': _checkoutSettings?.brand.asString,
          'card': card.toMap(),
        },
      );

      log('$result', name: "HyperpayPlugin/platformResponse");

      final status = await paymentStatus(checkoutID);
      final String code = status['code'];

      if (code.paymentStatus == PaymentStatus.rejected) {
        throw HyperpayException("Rejected payment.", code, status['description']);
      } else {
        log('${code.paymentStatus}', name: "HyperpayPlugin/paymentStatus");
      }
    } catch (e) {
      log('$e', name: "HyperpayPlugin/pay");
      rethrow;
    }
  }

  /// Check for payment status using a checkout ID, this method is called
  /// once right after a transaction.
  Future<Map<String, dynamic>> paymentStatus(String checkoutID) async {
    try {
      final Response response = await post(
        _statusEndpoint,
        body: {
          'entityID': _checkoutSettings?.brand.entityID,
          'checkoutID': checkoutID,
        },
      );

      final Map<String, dynamic> _resBody = json.decode(response.body);

      log(
        '${_resBody['result']['code']}: ${_resBody['result']['description']}',
        name: "HyperpayPlugin/checkPaymentStatus",
      );

      return _resBody['result'];
    } catch (exception) {
      rethrow;
    }
  }
}
