#import "HyperpayPlugin.h"
#if __has_include(<hyperpay/hyperpay-Swift.h>)
#import <hyperpay/hyperpay-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "hyperpay-Swift.h"
#endif

@implementation HyperpayPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftHyperpayPlugin registerWithRegistrar:registrar];
}
@end
