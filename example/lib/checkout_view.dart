import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hyperpay/hyperpay.dart';

class CheckoutView extends StatefulWidget {
  const CheckoutView({
    Key? key,
    required this.checkoutID,
    required this.session,
  }) : super(key: key);

  final String checkoutID;
  final HyperpayPlugin session;

  @override
  _CheckoutViewState createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  TextEditingController holderNameController = TextEditingController();
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController expiryController = TextEditingController();
  TextEditingController cvvController = TextEditingController();

  late final BrandType brandType;

  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  @override
  void initState() {
    brandType = widget.session.checkoutSettings.brand.type;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Checkout"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            autovalidateMode: autovalidateMode,
            child: Builder(
              builder: (context) {
                return Column(
                  children: [
                    SizedBox(height: 10),
                    // Holder
                    TextFormField(
                      controller: holderNameController,
                      decoration: _inputDecoration(
                        label: "Card Holder",
                        hint: "Jane Jones",
                        icon: Icons.account_circle_rounded,
                      ),
                    ),
                    SizedBox(height: 10),
                    // Number
                    TextFormField(
                      controller: cardNumberController,
                      decoration: _inputDecoration(
                        label: "Card Number",
                        hint: "0000 0000 0000 0000",
                        icon: Icons.credit_card_rounded,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(brandType.maxLength),
                        CardNumberInputFormatter()
                      ],
                      validator: (String? number) => brandType.validateNumber(number ?? ""),
                    ),
                    SizedBox(height: 10),
                    // Expiry date
                    TextFormField(
                      controller: expiryController,
                      decoration: _inputDecoration(
                        label: "Expiry Date",
                        hint: "MM/YY",
                        icon: Icons.date_range_rounded,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                        CardMonthInputFormatter(),
                      ],
                      validator: (String? date) => CardInfo.validateDate(date ?? ""),
                    ),
                    SizedBox(height: 10),
                    // CVV
                    TextFormField(
                      controller: cvvController,
                      decoration: _inputDecoration(
                        label: "CVV",
                        hint: "000",
                        icon: Icons.confirmation_number_rounded,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                      ],
                      validator: (String? cvv) => CardInfo.validateCVV(cvv ?? ""),
                    ),
                    SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          final bool valid = Form.of(context)?.validate() ?? false;
                          if (valid) {
                            // Make a CardInfo from the controllers
                            CardInfo card = CardInfo(
                              holder: holderNameController.text,
                              cardNumber: cardNumberController.text,
                              cvv: cvvController.text,
                              expiryMonth: expiryController.text.split('/')[0],
                              expiryYear: '20' + expiryController.text.split('/')[1],
                            );

                            // Start transaction
                            await widget.session.pay(widget.checkoutID, card);

                            await widget.session.paymentStatus(widget.checkoutID);
                          } else {
                            setState(() {
                              autovalidateMode = AutovalidateMode.onUserInteraction;
                            });
                          }
                        },
                        child: Text('PAY'),
                      ),
                    )
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({String? label, String? hint, IconData? icon}) {
    return InputDecoration(
      hintText: hint,
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
      prefixIcon: Icon(icon),
    );
  }
}
