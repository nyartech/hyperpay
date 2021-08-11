import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:hyperpay/hyperpay.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _checkoutID = '';

  Future<void> getCheckoutID() async {
    String? checkoutID;

    // Prepare your brand
    Brand brand = Brand(
      entityID: '',
      type: BrandType.visa,
    );

    // Initialize HyperPay session
    HyperpayPlugin hyperpay = HyperpayPlugin(
      mode: PaymentMode.test,
      checkoutSettings: CheckoutSettings(
        brand: brand,
        amount: 10.0,
        host: 'YOUR_HOST',
        path: '',
        //additionalParams: {},
      ),
    );

    try {
      checkoutID = await hyperpay.checkoutID;

      setState(() {
        _checkoutID = checkoutID ?? '';
      });
    } on PlatformException {}
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                child: Text('Get Checkout ID'),
                onPressed: () {
                  getCheckoutID();
                },
              ),
              if (_checkoutID.isNotEmpty)
                Center(
                  child: Text('CheckoutID: $_checkoutID\n'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
