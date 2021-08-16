import 'package:hyperpay/hyperpay.dart';

class TestConfig implements HyperpayConfig {
  String? creditcardEntityID = '';
  String? madaEntityID = '';
  PaymentMode paymentMode = PaymentMode.test;
}

class LiveConfig implements HyperpayConfig {
  String? creditcardEntityID = '';
  String? madaEntityID = '';
  PaymentMode paymentMode = PaymentMode.live;
}
