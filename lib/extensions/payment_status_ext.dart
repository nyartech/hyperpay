import 'package:hyperpay/enums/payment_status.dart';

extension PaymentStatusFromRegExp on String {
  PaymentStatus get paymentStatus {
    final successRegExp = RegExp(r"^(000\.000\.|000\.100\.1|000\.[36]|000\.400\.0[^3]|000\.400\.[0-1]{2}0)");
    final pendingRegExp = RegExp(r"^(000\.200|800\.400\.5|100\.400\.500)");

    if (successRegExp.hasMatch(this)) {
      return PaymentStatus.successful;
    } else if (pendingRegExp.hasMatch(this)) {
      return PaymentStatus.pending;
    } else {
      return PaymentStatus.rejected;
    }
  }
}
