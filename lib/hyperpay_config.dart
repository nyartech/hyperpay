import 'package:hyperpay/enums/payment_mode.dart';

class HyperpayConfig {
  String? creditcardEntityID;
  String? madaEntityID;
  PaymentMode paymentMode = PaymentMode.none;
}
