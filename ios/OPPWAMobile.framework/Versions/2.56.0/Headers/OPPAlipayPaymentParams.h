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


#import <Foundation/Foundation.h>
#import "OPPPaymentParams.h"

__deprecated_msg("The OPPAlipayPaymentParams class is formally deprecated. To make Alipay transaction, instead use OPPPaymentParams class with payment brand 'ALIPAY'.")
/**
 Class to encapsulate all necessary transaction parameters for performing an Alipay transaction.
 
 @warning **Deprecated:** The `OPPAlipayPaymentParams` class is formally deprecated in 1.4.0. To make Alipay transaction, instead use `OPPPaymentParams` class with payment brand 'ALIPAY'.
 */

NS_ASSUME_NONNULL_BEGIN
@interface OPPAlipayPaymentParams : OPPPaymentParams

/// @name Initialization

/// :nodoc:
- (instancetype)initWithCheckoutID:(NSString *)checkoutID paymentBrand:(NSString *)paymentBrand error:(NSError * _Nullable __autoreleasing *)error NS_UNAVAILABLE;

/**
 Creates an object representing an Alipay transaction.
 
 @param checkoutID The checkout ID of the transaction. Must be not nil or empty.
 @param error The error that occurred while validating payment parameters. See code attribute (OPPErrorCode) and NSLocalizedDescription to identify the reason of failure.
 @return Returns an object representing an Alipay transaction.
 */
+ (nullable instancetype)alipayPaymentParamsWithCheckoutID:(NSString *)checkoutID error:(NSError **)error;

/**
 Creates an object representing an Alipay transaction.
 
 @param checkoutID The checkout ID of the transaction. Must be not nil or empty.
 @param error The error that occurred while validating payment parameters. See code attribute (OPPErrorCode) and NSLocalizedDescription to identify the reason of failure.
 @return Returns an object representing an Alipay transaction.
 */
- (nullable instancetype)initWithCheckoutID:(NSString *)checkoutID error:(NSError **)error NS_DESIGNATED_INITIALIZER;
@end
NS_ASSUME_NONNULL_END
