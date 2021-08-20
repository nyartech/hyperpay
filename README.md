# HyperPay Flutter Plugin

This plugin is a wrapper around [HyperPay iOS and Android SDK](https://wordpresshyperpay.docs.oppwa.com/tutorials/mobile-sdk), it's still in **alpha** release, and supports limited set of functionality and brands.

*Note: this plugin is unofficial.*

## Support Checklist
- [x] Brands: **VISA**, **MasterCard**, **MADA**
- [x] Card number and year fields mask
- [x] Get a checkout ID
- [x] Get payment status
- [x] Perform sync/async payment

## Getting Started

### iOS Setup

//TODO

### Android Setup
1. Download the oppwa.mobile android library.
2. Right click on the android directory and click **Open in Android Studio**.
3. Switch to **project** view.
4. Right click on your main app directory, then click **New > Directory**, name it `oppwa.mobile`.
5. Drag and drop the aar file you just downloaded into the directory.
6. Copy [this build.gradle file](https://github.com/nyartech/hyperpay/blob/main/example/android/oppwa.mobile/build.gradle) content and make a new file inside the same firectory with same content.
7. Open `android/app/build.gradle` and add the following lines:
```
implementation project(“:oppwa.mobile”)
```
8. Open `app/build.gradle` and make sure that the `minSdkVersion` is **21**
9. Open settings.gradle, and make sure you have this line to the top:
```
include ':oppwa.mobile'
```
10. Click on **Build > Make Project**.
11. Open your [AndroidManifest.xml](https://github.com/nyartech/hyperpay/blob/main/example/android/app/src/main/AndroidManifest.xml), and make sure it looks like the example app.
<br />**IMPORTANT:** the scheme you choose should match exactly your application ID but without any underscores, and then append `.payments` to it. 
<br />For example: `com.nyartech.hyperpay_example` becomes `com.nyartech.hyperpayexample.payments`

### Setup Required Endpoints
It's important to setup your own server with 2 endpoints:
1. Get Checkout ID
2. Get payment status

Find full details on [set up your server](https://wordpresshyperpay.docs.oppwa.com/tutorials/mobile-sdk/integration/server) page.

After that, setup 2 `Uri` objects with your endpoints specifications, refer to [`example/lib/config`](https://github.com/nyartech/hyperpay/blob/main/example/lib/endpoint_setup.dart) for an example.

```dart
String _host = 'YOUR_HOST';

Uri checkoutEndpoint = Uri(
  scheme: 'https',
  host: _host,
  path: '',
);

Uri statusEndpoint = Uri(
  scheme: 'https',
  host: _host,
  path: '',
);
```

### Setup HyperPay App Configuration

The first time you launch your app, setup the plugin with your configurations, it's highly recommended to use flavors to switch between modes.

Implement `HyperpayConfig` class and put your merchant entity IDs provided by HyperPay.

```dart
class TestConfig implements HyperpayConfig {
  String? creditcardEntityID = '';
  String? madaEntityID = '';
  PaymentMode paymentMode = PaymentMode.test;
}
```

Then you might consider using **dart environment variables** to switch between Test and Live modes.

```dart
const bool isDev = bool.fromEnvironment('DEV');

void setup() async {
  await HyperpayPlugin.instance.setup(
    config: isDev? TestConfig() : LiveConfig(),
    checkoutEndpoint: checkoutEndpoint,
    statusEndpoint: statusEndpoint,
  );
}
```

## Usage

Refer to `example` directory for a full app usage example. As this is still an alpha release, consider testing your implementation first in the example app before starting in your own app.

<p>
   <img src="https://user-images.githubusercontent.com/41123719/129632623-736b4f9a-ee70-48a0-a18f-e627b2a6f067.png" atl="Example app" width="200"/>     
   <img src="https://user-images.githubusercontent.com/41123719/129632797-3111847e-9feb-4768-8e10-da81a26507d5.gif" atl="Auto detect brand" width="200"/>  
   <img src="https://user-images.githubusercontent.com/41123719/129632867-273027cd-d31e-4ba9-9b45-9de2e412d614.gif" atl="Auto detect brand 2" width="200"/>
   <img src="https://user-images.githubusercontent.com/41123719/129699558-ef1fafb7-099c-4b70-9a2d-b8a13f1a3ac1.gif" atl="Successful payment flow" width="200"/>
</p>

## Contribution

For any problems, please file an issue.
Contributions are more than welcome to fix bugs or extend this plugin!

## Maintainers
- [Mais Alheraki](https://fairybits.com)
