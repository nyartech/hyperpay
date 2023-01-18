class TokenCardValue {
  final String tokenId;
  final String lastFourDigits;

  TokenCardValue.fromMap(Map<String, dynamic> m)
      : tokenId = m['tokenID'],
        lastFourDigits = m['last4Digits'];
}
