import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:hyperpay/hyperpay.dart';
import 'package:mocktail/mocktail.dart';

class HyperPayPluginMock extends Mock implements HyperpayPlugin {}

Client httpclinet = Client();
void main() {
  const MethodChannel channel = MethodChannel('hyperpay');
  HttpOverrides.global = null;

  TestWidgetsFlutterBinding.ensureInitialized();

  late HyperpayPlugin plugin;
  late BrandType brand;
  late CardInfo cardInfo;
  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
    plugin = HyperPayPluginMock();
    brand = BrandType.visa;
    cardInfo = CardInfo(
        holder: 'Big Danny',
        cardNumber: '4200000000000000',
        cvv: '000',
        expiryMonth: '12',
        expiryYear: '55');
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('Pay using checkout ID', () async {});
  test('easyPay using checkout ID returns', () async {
    when(
      () => plugin.easyPay(
          checkoutId: any(named: 'checkoutId'), brand: brand, card: cardInfo),
    ).thenAnswer((_) => Future.value());

    expectLater(plugin.easyPay(checkoutId: '42', brand: brand, card: cardInfo),
        completes);
  });
  test('easyPay using checkout ID throws', () async {
    when(
      () => plugin.easyPay(
          checkoutId: any(named: 'checkoutId'), brand: brand, card: cardInfo),
    ).thenAnswer((_) => Future.error(Exception()));

    expectLater(plugin.easyPay(checkoutId: '42', brand: brand, card: cardInfo),
        throwsException);
  });
  test('Get a specific payment status', () async {});
}
