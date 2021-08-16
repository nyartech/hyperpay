import 'package:hyperpay/enums/payment_mode.dart';

extension PaymentModeExtension on PaymentMode {
  String get string {
    switch (this) {
      case PaymentMode.live:
        return 'LIVE';
      case PaymentMode.test:
        return 'TEST';
      default:
        return '';
    }
  }
}
