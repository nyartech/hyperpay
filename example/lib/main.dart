import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:hyperpay/hyperpay.dart';
import 'package:hyperpay_example/checkout_view.dart';

import 'brand_button.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Initialize HyperPay session
  late HyperpayPlugin hyperpay;

  initPaymentSession(
    Brand brand,
    double amount,
    String host,
    String checkoutPath,
    String paymentPath,
  ) {
    hyperpay = HyperpayPlugin(
      mode: PaymentMode.test,
      checkoutSettings: CheckoutSettings(
        brand: brand,
        amount: amount,
        host: host,
        path: checkoutPath,
        additionalParams: {
          'merchantTransactionId': '#123456',
        },
      ),
      paymentSettings: PaymentSettings(
        host: host,
        path: paymentPath,
      ),
    );
  }

  Future<void> getCheckoutID(BrandType brandType, BuildContext context) async {
    try {
      try {
        final String checkoutID = await hyperpay.getCheckoutID;

        if (checkoutID.isNotEmpty) {
          Navigator.of(context).push(
            MaterialPageRoute(
              fullscreenDialog: true,
              builder: (_) => CheckoutView(
                checkoutID: checkoutID,
                session: hyperpay,
              ),
            ),
          );
        }
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
      home: Scaffold(
        appBar: AppBar(
          title: const Text('HyperPay example app'),
        ),
        body: Builder(
          builder: (context) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BrandButton(
                    brandName: 'VISA',
                    color: Colors.blue,
                    onPressed: () {
                      initPaymentSession(
                        BrandType.visa.brand(''),
                        10.0,
                        'YOUR_HOST',
                        '',
                        '',
                      );

                      getCheckoutID(hyperpay.checkoutSettings.brand.type, context);
                    },
                  ),
                  BrandButton(
                    brandName: 'MASTER CARD',
                    color: Colors.red,
                    onPressed: () {
                      initPaymentSession(
                        BrandType.visa.brand('8a8294174b7ecb28014b9699220015ca'),
                        10.0,
                        'YOUR_HOST',
                        '',
                        '',
                      );
                      getCheckoutID(BrandType.mastercard, context);
                    },
                  ),
                  BrandButton(
                    brandName: 'MADA',
                    color: Colors.green,
                    onPressed: () {
                      initPaymentSession(
                        BrandType.mada.brand('8a8294174b7ecb28014b9699220015ca'),
                        10.0,
                        'YOUR_HOST',
                        '',
                        '',
                      );
                      getCheckoutID(BrandType.mada, context);
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
