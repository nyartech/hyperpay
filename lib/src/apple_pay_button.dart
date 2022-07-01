// Copyright 2022 NyarTech LLC. All rights reserved.
// Use of this source code is governed by a BSD-style license
// that can be found in the LICENSE file.

part of hyperpay;

/// A button widget that follows the Apple Pay button styles and design
/// guidelines. This widget will draw the native Apply Pay button from PassKit
class ApplePayButton extends StatelessWidget {
  /// The default width for the Apple Pay Button.
  static const double minimumButtonWidth = 100;

  /// The default height for the Apple Pay Button.
  static const double minimumButtonHeight = 30;

  /// The constraints used to limit the size of the button.
  final BoxConstraints constraints;

  /// Called when the button is pressed.
  final VoidCallback? onPressed;

  /// The style of the Apple Pay button, to be adjusted based on the color
  /// scheme of the application.
  final ApplePayButtonStyle style;

  /// The tyoe of button depending on the activity initiated with the payment
  /// transaction.
  final ApplePayButtonType type;

  /// Creates an Apple Pay button widget with the parameters specified.
  ApplePayButton({
    Key? key,
    this.onPressed,
    this.style = ApplePayButtonStyle.black,
    this.type = ApplePayButtonType.plain,
  })  : constraints = BoxConstraints.tightFor(
          width: type.minimumWidth,
          height: minimumButtonHeight,
        ),
        super(key: key) {
    assert(constraints.debugAssertIsValid());
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: constraints,
      child: _platformButton,
    );
  }

  /// Wrapper method to deliver the button only to applitcations running on iOS.
  Widget get _platformButton {
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        return _UiKitApplePayButton(
          onPressed: onPressed,
          style: style,
          type: type,
        );
      default:
        throw UnsupportedError(
            'Platform $defaultTargetPlatform does not support Apple Pay');
    }
  }

  static bool get supported => defaultTargetPlatform == TargetPlatform.iOS;
}

/// Draw the Apple Pay button through a [PlatforView].
class _UiKitApplePayButton extends StatelessWidget {
  static const buttonId = 'plugins.nyartech.com/hyperpay/apple_pay_button';
  late final MethodChannel? methodChannel;

  final VoidCallback? onPressed;
  final ApplePayButtonStyle style;
  final ApplePayButtonType type;

  _UiKitApplePayButton({
    Key? key,
    this.onPressed,
    this.style = ApplePayButtonStyle.black,
    this.type = ApplePayButtonType.plain,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UiKitView(
      viewType: buttonId,
      creationParamsCodec: const StandardMessageCodec(),
      creationParams: {'style': style.name, 'type': type.name},
      onPlatformViewCreated: (viewId) {
        methodChannel = MethodChannel('$buttonId/$viewId');
        methodChannel?.setMethodCallHandler((call) async {
          if (call.method == 'onPressed') onPressed?.call();
          return;
        });
      },
    );
  }
}
