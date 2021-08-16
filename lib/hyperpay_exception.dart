class HyperpayException implements Exception {
  /// A message describing the error coming from HyperPay server.
  final String message;

  /// The code of the error from HyperPay API.
  final String? code;

  /// More details about the error.
  final String? details;

  const HyperpayException([this.message = "", this.code, this.details]);

  String toString() {
    return "$code: $message, details: $details";
  }
}
