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

#import "OPPPaymentParams.h"

__deprecated_msg("The OPPPayPalPaymentParams class is formally deprecated. To make PayPal transaction, instead use OPPPaymentParams class with payment brand 'PAYPAL'.")
/**
 Class to encapsulate all necessary transaction parameters for performing a PayPal transaction.
 
 @warning **Deprecated:** The `OPPPayPalPaymentParams` class is formally deprecated in 1.4.0. To make PayPal transaction, instead use `OPPPaymentParams` class with payment brand 'PAYPAL'.
 */

NS_ASSUME_NONNULL_BEGIN
@interface OPPPayPalPaymentParams : OPPPaymentParams

/// @name Initialization

/// :nodoc:
- (instancetype)initWithCheckoutID:(NSString *)checkoutID paymentBrand:(NSString *)paymentBrand error:(NSError * _Nullable __autoreleasing *)error NS_UNAVAILABLE;

/**
 Creates an object representing a PayPal transaction.
 
 @param checkoutID The checkout ID of the transaction. Must be not `nil` or empty.
 @param error The error that occurred while validating payment parameters. See code attribute (`OPPErrorCode`) and `NSLocalizedDescription` to identify the reason of failure.
 @return Returns an object representing a PayPal transaction.
 */
+ (nullable instancetype)payPalPaymentParamsWithCheckoutID:(NSString *)checkoutID error:(NSError **)error;

/**
 Creates an object representing a PayPal transaction.
 
 @param checkoutID The checkout ID of the transaction. Must be not `nil` or empty.
 @param error The error that occurred while validating payment parameters. See code attribute (`OPPErrorCode`) and `NSLocalizedDescription` to identify the reason of failure.
 @return Returns an object representing a PayPal transaction.
 */
- (nullable instancetype)initWithCheckoutID:(NSString *)checkoutID error:(NSError **)error NS_DESIGNATED_INITIALIZER;
@end
NS_ASSUME_NONNULL_END

