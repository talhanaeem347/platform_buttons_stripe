//
//  Generated file. Do not edit.
//

// clang-format off

#import "GeneratedPluginRegistrant.h"

#if __has_include(<pay_ios/PayPlugin.h>)
#import <pay_ios/PayPlugin.h>
#else
@import pay_ios;
#endif

#if __has_include(<stripe_ios/StripeIosPlugin.h>)
#import <stripe_ios/StripeIosPlugin.h>
#else
@import stripe_ios;
#endif

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [PayPlugin registerWithRegistrar:[registry registrarForPlugin:@"PayPlugin"]];
  [StripeIosPlugin registerWithRegistrar:[registry registrarForPlugin:@"StripeIosPlugin"]];
}

@end
