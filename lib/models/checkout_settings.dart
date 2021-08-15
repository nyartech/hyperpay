import 'package:hyperpay/brands.dart';

/// This class wraps the required params to get a `checkoutID`
/// from HyperPay **server-to-server**, meaning that these params
/// are sent later in the body of your call to get a `checkoutID`
/// to your server.
///
/// See [HyperpayPlugin]
///
/// @params
///
/// `brand`: a [Brand] that has the type and entity ID of the
/// card the user will pay with.
///
/// `host`: your own server host, e.g. my-server.com
///
/// `path`: the full path on your server for the endpoint
/// where you placed the code to get a `checkoutID` from HyperPay.
///
/// Check [the guide to setup your server](https://wordpresshyperpay.docs.oppwa.com/tutorials/mobile-sdk/integration/server).
///
/// `additionalParams`: HyperPay allows sending additional params
/// to help you identify payments with your own DB.
/// Insert them as key/valye pairs.
///
/// Check [here](https://wordpresshyperpay.docs.oppwa.com/reference/parameters#customer) for full list of allowed parameters.
///
class CheckoutSettings {
  CheckoutSettings({
    required this.brand,
    required this.host,
    required this.path,
    required this.amount,
    this.additionalParams = const {},
  });

  Brand brand;
  String host;
  String path;
  double amount;
  Map<String, dynamic> additionalParams;
}
