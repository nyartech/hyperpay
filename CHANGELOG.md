## 0.0.9-alpha

* Fix: Android bug on API levels 30 and above causing Custom Chrome Tabs to crash.
* Feat: fallback support for phones with no Custome Chrome Tabs installed.
## 0.0.8-alpha

* Fix: case-sensitive application ID on Android.
## 0.0.7-alpha

* Fix a bug with `Content-Type` header.
* Throw an exception for badly structured backend response.

## 0.0.6-alpha

* Update iOS SDK.
## 0.0.5-alpha

* **Breaking**: refactor and update the library API.
* Bug fixes with platform code on Android and iOS.
* Enabled providing headers to endpoints configurations.
## 0.0.4-alpha

* Use ChromeCustomTabs for Android's authentication page.
* Add a canceled result and handle it in case hte user leave the authentication browser page before completing the transaction.
* Accepting headers in [CheckoutSettings](lib/src/models/checkout_settings.dart) to enable making authorized calls to checkout & status endpoints.

## 0.0.3-alpha

* Fixed a bug with sending additional params on checkout.
* Removed dependency over Flutter.
## 0.0.2-alpha

* Format plugin dart files.
* Update README.

## 0.0.1-alpha

* Initial alpha release.
