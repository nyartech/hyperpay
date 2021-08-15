enum PaymentMode { test, live }

extension PaymentModeExtension on PaymentMode {
  String get string {
    switch (this) {
      case PaymentMode.live:
        return 'LIVE';
      case PaymentMode.test:
        return 'TEST';
    }
  }
}
