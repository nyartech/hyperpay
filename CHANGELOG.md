## 1.0.0-dev.6

* Upgrade to HyperPay SDK version 4.8.0.

## 1.0.0-dev.5

* Fix: bumping to SDK version 4.6.0
* BREAKING: `pay` method no longer checks for the pament status automatically, you need to call `paymentStatus` yourself.
* BREAKING: the iOS SDK is now depended on from a git repository, to make the size of the plugin smaller.
  1. Open Podfile, and update it:
  ```ruby
  target 'Runner' do
    use_frameworks!
    use_modular_headers!

    flutter_install_all_ios_pods File.dirname(File.realpath(__FILE__))

    # The line is new, add it to your app's Podfile
    pod 'oppwamobile', :git => 'https://github.com/nyartech/oppwamobile-ios-sdk.git'

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

## 1.0.0-dev.3

* Fix: bumping to SDK version 4.5.0
* BREAKING: the AAR files are now bundled with the plugin, therefore a couple changes are needed to upgrade to this version:
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
## 1.0.0-dev.2

* Fix: Apple Pay transactions was being rejected.
## 1.0.0-dev.1

* Feat: Apple Pay

## 0.0.10-alpha

* Fix: Kotlin null-safety error. 
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
