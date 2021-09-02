import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';

Client httpclinet = Client();
void main() {
  const MethodChannel channel = MethodChannel('hyperpay');
  HttpOverrides.global = null;

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('Pay using checkout ID', () async {});
  test('Get a specific payment status', () async {});
}
