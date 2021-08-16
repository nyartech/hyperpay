import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:hyperpay/hyperpay.dart';
import 'package:hyperpay_example/checkout_view.dart';
import 'package:hyperpay_example/constants.dart';

void main() {
  // Setup using your own endpoints.
  // https://wordpresshyperpay.docs.oppwa.com/tutorials/mobile-sdk/integration/server.
  String _host = 'YOUR_HOST';
  Uri _checkoutEndpoint = Uri(
    scheme: 'https',
    host: _host,
    path: '',
  );
  Uri _statusEndpoint = Uri(
    scheme: 'https',
    host: _host,
    path: '',
  );

  HyperpayPlugin.instance.setup(
    mode: PaymentMode.test,
    config: TestConfig(),
    checkoutEndpoint: _checkoutEndpoint,
    statusEndpoint: _statusEndpoint,
  );

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<void> getCheckoutID(BuildContext context) async {
    try {
      try {
        Navigator.of(context).push(
          MaterialPageRoute(
            fullscreenDialog: true,
            builder: (_) => CheckoutView(),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error'),
          ),
        );
      }
    } on PlatformException {}
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CheckoutView(),
    );
  }
}
