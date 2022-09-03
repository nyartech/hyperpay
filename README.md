# HyperPay Flutter Plugin

<img src="https://user-images.githubusercontent.com/2434978/130263399-3a812e3a-5794-4428-be3f-32b551752160.png" width="500" />


This plugin is a wrapper around [HyperPay iOS and Android SDK](https://wordpresshyperpay.docs.oppwa.com/tutorials/mobile-sdk), it's still in **alpha** release, and supports limited set of functionality and brands.

*Note: this plugin is unofficial.*

[![pub package](https://img.shields.io/pub/v/hyperpay.svg)](https://pub.dev/packages/hyperpay)

## Support Checklist
✔️ Credit Card payment **VISA**, **MasterCard**
<br />✔️ Local Saudi payment with **MADA**
<br />✔️ Apple Pay
<br />✔️ Check payment status
<br />✔️ Custom UI
<br />✖️ Ready UI

## Getting Started

### iOS Setup
1. Add your Bundle Identifier as a URL Type.
<br />Open ios folder using Xcode, make sure you select Runner traget, then go to **Info** tab, and there add a new URL type, then paste your Bundle Identifier and append `.payments` to it.
<br /><img src="https://user-images.githubusercontent.com/41123719/130457061-1766b8e4-ab99-469f-81d2-58c2b99448af.png" atl="Xcode URL type" width="700"/>

2. Open Podfile, and paste the following inside of it:
```ruby
target 'Runner' do
  use_frameworks!
  use_modular_headers!

  flutter_install_all_ios_pods File.dirname(File.realpath(__FILE__))

  $static_framework = ['hyperpay']

  pre_install do |installer|
    Pod::Installer::Xcode::TargetValidator.send(:define_method, :verify_no_static_framework_transitive_dependencies) {}
    installer.pod_targets.each do |pod|
        if $static_framework.include?(pod.name)
          def pod.build_type;
            Pod::BuildType.static_library
          end
        end
      end
  end
end
```

### Android Setup
1. Open `android/app/build.gradle` and add the following lines:
```
implementation (name:'oppwa.mobile-4.5.0-release', ext:'aar')
```
2. Open `app/build.gradle` and make sure that the `minSdkVersion` is **21**, and `compileSdkVersion` is **33**.
3. Open your [AndroidManifest.xml](https://github.com/nyartech/hyperpay/blob/main/example/android/app/src/main/AndroidManifest.xml), and make sure it looks like the example app.
<br />**IMPORTANT:** the scheme you choose should match exactly your application ID but without any underscores, and then append `.payments` to it. 
<br />For example: `com.nyartech.hyperpay_example` becomes `com.nyartech.hyperpayexample.payments`

#### Migration to v1.0.0
On older versions of the plugin, adding the AAR SDK file manually on Android was required. Now it's not. To migrate:
1. Remove any of these dependencies in your `app/build.gradle`:
  ```groovy
  implementation project(":oppwa.mobile")
  implementation "androidx.appcompat:appcompat:1.3.1"
  implementation "com.google.android.material:material:1.4.0"
  implementation "com.google.android.gms:play-services-base:17.6.0"
  ```
2. Add a dependency over the AAR file:
  ```groovy
  implementation (name:'oppwa.mobile-4.5.0-release', ext:'aar')
  ```
3. in `settings.gradle`, remove the following line:
  ```groovy
  include ':oppwa.mobile'
  ```
4. Finally, remove the folder `oppwa.mobile` from the root `android` folder in your app.
  
### Setup Required Endpoints
It's important to setup your own server with 2 endpoints:
1. Get Checkout ID
2. Get payment status

Find full details on [set up your server](https://wordpresshyperpay.docs.oppwa.com/tutorials/mobile-sdk/integration/server) page.

After that, setup 2 `Uri` objects with your endpoints specifications, refer to [`example/lib/constants`](https://github.com/nyartech/hyperpay/blob/main/example/lib/constants.dart) for an example.

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

### Setup HyperPay Environment Configuration

The first time you launch your app, setup the plugin with your configurations, it's highly recommended to use flavors to switch between modes.

Implement `HyperpayConfig` class and put your merchant entity IDs as provided to you by HyperPay.

```dart
class TestConfig implements HyperpayConfig {
  @override
  String? creditcardEntityID = '';

  @override
  String? madaEntityID = '';

  @override
  String? applePayEntityID = '';

  @override
  Uri checkoutEndpoint = _checkoutEndpoint;

  @override
  Uri statusEndpoint = _statusEndpoint;

  @override
  PaymentMode paymentMode = PaymentMode.test;
}
```

Then you might consider using **Dart environment variables** to switch between Test and Live modes.

```dart
const bool isDev = bool.fromEnvironment('DEV');

void setup() async {
  await HyperpayPlugin.instance.setup(
    config: isDev? TestConfig() : LiveConfig(),
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
