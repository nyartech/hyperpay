import 'package:hyperpay/hyperpay.dart';

class TestConfig implements HyperpayConfig {
  @override
  String? creditcardEntityID = '8ac7a4c8758e14880175937acdf00ff6';
  @override
  String? madaEntityID = '8ac7a4c8758e14880175937bc5550ffc';
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
  String? creditcardEntityID = '8acda4ca75da9d130175ef7452ff37e6';
  @override
  String? madaEntityID = '8acda4ca75da9d130175ef74e0db37ea';
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

String _host = 'europe-west3-mawidy.cloudfunctions.net';

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