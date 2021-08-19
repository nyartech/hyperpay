import 'package:flutter/material.dart';

import 'package:hyperpay/hyperpay.dart';
import 'package:hyperpay_example/constants.dart';
import 'package:hyperpay_example/endpoint_setup.dart';
import 'package:hyperpay_example/checkout_view.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    setup();
    super.initState();
  }

  setup() async {
    await HyperpayPlugin.instance.setup(
      config: TestConfig(),
      checkoutEndpoint: checkoutEndpoint,
      statusEndpoint: statusEndpoint,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CheckoutView(),
    );
  }
}
