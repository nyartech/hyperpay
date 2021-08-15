//
// Copyright (c) 2020 by ACI Worldwide, Inc.
// All rights reserved.
//
// This software is the confidential and proprietary information
// of ACI Worldwide Inc ("Confidential Information"). You shall
// not disclose such Confidential Information and shall use it
// only in accordance with the terms of the license agreement
// you entered with ACI Worldwide Inc.
//

@import UIKit;
#import "OPPCheckoutPaymentMethod.h"

NS_ASSUME_NONNULL_BEGIN
/**
 A constant to be used instead of specific card brand. The brand will be detected automatically based on card number.
 */
extern NSString *const OPPPaymentBrandCard;

/**
 Class that extends UIButton in order to esily integrate separate payment methods in the app.
 
 By default button contains appropriate logo if a valid payment method is set. Button can be fully customized as common UIButton.
 
 To create and submit a transaction, use `-[OPPCheckoutProvider presentCheckoutWithPaymentBrand:loadingHandler:completionHandler:cancelHandler:]` in button action method.
 */
@interface OPPPaymentButton : UIButton

/// @name Initialization

/**
 Creates and returns payment button initialized with the payment brand.
 @param paymentBrand Payment brand for the transaction.
 */
+ (instancetype)paymentButtonWithPaymentBrand:(NSString *)paymentBrand;

/**
 Creates and returns payment button initialized with the payment method.
 @param paymentBrand Payment brand for the transaction.
 */
- (instancetype)initWithPaymentBrand:(NSString *)paymentBrand;

/// @name Properties

/**
 Payment brand for the transaction that is used to display an appropriate logo.
 Logo will be loaded automatically from the Server.
 To use your own image for a button, set it before initializing the payment brand.
 */
@property (nonatomic, copy) NSString *paymentBrand;

/// @name Deprecated properties

/**
 Payment method for the transaction that is used to display an appropriate logo.
 @warning **Deprecated:** Use `paymentBrand` instead
 */
@property (nonatomic) OPPCheckoutPaymentMethod paymentMethod DEPRECATED_ATTRIBUTE;

@end

/// Deprecated methods
@interface OPPPaymentButton (Deprecated)
/**
 Creates and returns payment button initialized with the payment brand.
 @param paymentMethod Payment method for the transaction.
 @warning **Deprecated:** Use `+paymentButtonWithPaymentBrand:` instead
 */
+ (instancetype)paymentButtonWithPaymentMethod:(OPPCheckoutPaymentMethod)paymentMethod DEPRECATED_MSG_ATTRIBUTE("- Use +paymentButtonWithPaymentBrand: instead.");

/**
 Creates and returns payment button initialized with the payment method.
 @param paymentMethod Payment method for the transaction.
 @warning **Deprecated:** Use `-initWithPaymentBrand:` instead
 */
- (instancetype)initWithPaymentMethod:(OPPCheckoutPaymentMethod)paymentMethod DEPRECATED_MSG_ATTRIBUTE("- Use -initWithPaymentBrand: instead.");
@end
NS_ASSUME_NONNULL_END
