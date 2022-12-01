import 'package:hyperpay/hyperpay.dart';

class TestConfig implements HyperpayConfig {
  @override
  String? creditcardEntityID = '';
  @override
  String? madaEntityID = '';
  @override
  String? applePayEntityID = '';
  @override
  Uri checkoutEndpoint = _checkoutEndpoint;
  @override
  Uri statusEndpoint = _statusEndpoint;
  @override
  PaymentMode paymentMode = PaymentMode.test;
}

class LiveConfig implements HyperpayConfig {
  @override
  String? creditcardEntityID = '';
  @override
  String? madaEntityID = '';
  @override
  String? applePayEntityID = '';
  @override
  Uri checkoutEndpoint = _checkoutEndpoint;
  @override
  Uri statusEndpoint = _statusEndpoint;
  @override
  PaymentMode paymentMode = PaymentMode.live;
}
// Setup using your own endpoints.
// https://wordpresshyperpay.docs.oppwa.com/tutorials/mobile-sdk/integration/server.

String _host = '';

Uri _checkoutEndpoint = Uri(
  scheme: 'https',
  host: _host,
  path: 'prepareCheckoutRequest',
);

Uri _statusEndpoint = Uri(
  scheme: 'https',
  host: _host,
  path: 'checkPaymentStatus',
);