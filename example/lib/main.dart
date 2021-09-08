import 'package:flutter/material.dart';

import 'package:hyperpay_example/checkout_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CheckoutView(),
    );
  }
}
