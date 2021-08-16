import 'package:hyperpay/hyperpay.dart';

class TestConfig implements HyperpayConfig {
  String? creditcardEntityID = '';
  String? madaEntityID = '';
}

class LiveConfig implements HyperpayConfig {
  String? creditcardEntityID = '';
  String? madaEntityID = '';
}
