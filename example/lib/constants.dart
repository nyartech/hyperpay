import 'package:hyperpay/hyperpay.dart';

class TestConfig implements HyperpayConfig {
  String? creditcardEntityID = '';
  String? madaEntityID = '';
  Uri checkoutEndpoint = _checkoutEndpoint;
  Uri statusEndpoint = _statusEndpoint;
  PaymentMode paymentMode = PaymentMode.test;
}

class LiveConfig implements HyperpayConfig {
  String? creditcardEntityID = '';
  String? madaEntityID = '';
  Uri checkoutEndpoint = _checkoutEndpoint;
  Uri statusEndpoint = _statusEndpoint;
  PaymentMode paymentMode = PaymentMode.live;
}

// Setup using your own endpoints.
// https://wordpresshyperpay.docs.oppwa.com/tutorials/mobile-sdk/integration/server.

String _host = '';

Uri _checkoutEndpoint = Uri(
  scheme: 'https',
  host: _host,
  path: '',
);

Uri _statusEndpoint = Uri(
  scheme: 'https',
  host: _host,
  path: '',
);
