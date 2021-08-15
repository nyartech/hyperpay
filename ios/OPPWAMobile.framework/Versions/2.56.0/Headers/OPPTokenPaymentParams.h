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

/**
 Class to encapsulate all necessary transaction parameters for performing a token transaction.
 */

NS_ASSUME_NONNULL_BEGIN
@interface OPPTokenPaymentParams : OPPPaymentParams

/// @name Initialization

/// :nodoc:
- (instancetype)initWithCheckoutID:(NSString *)checkoutID paymentBrand:(NSString *)paymentBrand error:(NSError * _Nullable __autoreleasing *)error NS_UNAVAILABLE;

/**
 Creates an object representing a token transaction.
 
 @param checkoutID The checkout ID of the transaction. Must be not `nil` or empty.
 @param tokenID The identifier of the token that can be used to reference the token later.
 @param paymentBrand Payment brand of the tokenized transaction.
 @param error The error that occurred while validating payment parameters. See code attribute (`OPPErrorCode`) and `NSLocalizedDescription` to identify the reason of failure.
 @return Returns an object representing a token transaction, and `nil` if parameters are invalid.
 */
+ (nullable instancetype)tokenPaymentParamsWithCheckoutID:(NSString *)checkoutID tokenID:(NSString *)tokenID paymentBrand:(NSString *)paymentBrand error:(NSError **)error;

/**
 Creates an object representing a token transaction.
 
 @param checkoutID The checkout ID of the transaction. Must be not `nil` or empty.
 @param tokenID The identifier of the token that can be used to reference the token later.
 @param cardPaymentBrand The payment brand of the tokenized card.
 @param CVV The CVV code found on the card.
 @param error The error that occurred while validating payment parameters. See code attribute (`OPPErrorCode`) and `NSLocalizedDescription` to identify the reason of failure.
 @return Returns an object representing a token transaction, and `nil` if parameters are invalid.
 */
+ (nullable instancetype)tokenPaymentParamsWithCheckoutID:(NSString *)checkoutID tokenID:(NSString *)tokenID cardPaymentBrand:(NSString *)cardPaymentBrand CVV:(nullable NSString *)CVV error:(NSError **)error;

/**
 Creates an object representing a token transaction.
 
 @param checkoutID The checkout ID of the transaction. Must be not `nil` or empty.
 @param tokenID The identifier of the token that can be used to reference the token later.
 @param paymentBrand Payment method brand.
 @param error The error that occurred while validating payment parameters. See code attribute (`OPPErrorCode`) and `NSLocalizedDescription` to identify the reason of failure.
 @return Returns an object representing a token transaction, and `nil` if parameters are invalid.
 */
 - (nullable instancetype)initWithCheckoutID:(NSString *)checkoutID tokenID:(NSString *)tokenID paymentBrand:(NSString *)paymentBrand error:(NSError **)error NS_DESIGNATED_INITIALIZER;

/**
 Creates an object representing a token transaction.
 
 @param checkoutID The checkout ID of the transaction. Must be not `nil` or empty.
 @param tokenID The identifier of the token that can be used to reference the token later.
 @param cardPaymentBrand The payment brand of the tokenized card.
 @param CVV The CVV code found on the card.
 @param error The error that occurred while validating payment parameters. See code attribute (`OPPErrorCode`) and `NSLocalizedDescription` to identify the reason of failure.
 @return Returns an object representing a token transaction, and `nil` if parameters are invalid.
 */
- (nullable instancetype)initWithCheckoutID:(NSString *)checkoutID tokenID:(NSString *)tokenID cardPaymentBrand:(NSString *)cardPaymentBrand CVV:(nullable NSString *)CVV error:(NSError **)error NS_DESIGNATED_INITIALIZER;

/// @name Properties

/**
 The identifier of the token that can be used to reference the token later.
 */
@property (nonatomic, copy, readonly) NSString *tokenID;

/**
 The CVV code found on the card. Property should be set, if CVV check is required for transaction processing.
 */
@property (nonatomic, copy, readonly, nullable) NSString *CVV;

/** The number of installments the payment should be split into. */
@property (nonatomic, copy) NSNumber *numberOfInstallments;

/// @name Validation methods
/**
 Checks if the token identifier is valid to perform a transaction.
 
 @param tokenID The identifier of the token that can be used to reference the token later.
 @return `YES` if token identifier is alpha-numeric string of length 32.
 */
+ (BOOL)isTokenIDValid:(NSString *)tokenID;

/**
 Checks if the card CVV is filled with sufficient data to perform a transaction.
 
 @param CVV The card security code or CVV.
 @return `YES` if 3,4-digit number is provided.
 */
+ (BOOL)isCvvValid:(NSString *)CVV;

@end

/// Deprecated methods
@interface OPPTokenPaymentParams (Deprecated)
/**
 Creates an object representing a token transaction.
 
 @param checkoutID The checkout ID of the transaction. Must be not `nil` or empty.
 @param tokenID The identifier of the token that can be used to reference the token later.
 @param brand Payment method brand.
 @param error The error that occurred while validating payment parameters. See code attribute (`OPPErrorCode`) and `NSLocalizedDescription` to identify the reason of failure.
 @return Returns an object representing a token transaction, and `nil` if parameters are invalid.
 @warning **Deprecated:** Use `+tokenPaymentParamsWithCheckoutID:tokenID:paymentBrand:error:` instead
 */
+ (nullable instancetype)tokenPaymentParamsWithCheckoutID:(NSString *)checkoutID tokenID:(NSString *)tokenID brand:(OPPPaymentParamsBrand)brand error:(NSError **)error DEPRECATED_MSG_ATTRIBUTE("- Use +tokenPaymentParamsWithCheckoutID:tokenID:paymentBrand:error: instead.");

/**
 Creates an object representing a token transaction.
 
 @param checkoutID The checkout ID of the transaction. Must be not `nil` or empty.
 @param tokenID The identifier of the token that can be used to reference the token later.
 @param cardBrand The brand of the tokenized card.
 @param CVV The CVV code found on the card.
 @param error The error that occurred while validating payment parameters. See code attribute (`OPPErrorCode`) and `NSLocalizedDescription` to identify the reason of failure.
 @return Returns an object representing a token transaction, and `nil` if parameters are invalid.
 @warning **Deprecated:** Use `+tokenPaymentParamsWithCheckoutID:tokenID:cardPaymentBrand:CVV:error:` instead
 */
+ (nullable instancetype)tokenPaymentParamsWithCheckoutID:(NSString *)checkoutID tokenID:(NSString *)tokenID cardBrand:(OPPPaymentParamsBrand)cardBrand CVV:(nullable NSString *)CVV error:(NSError **)error DEPRECATED_MSG_ATTRIBUTE("- Use +tokenPaymentParamsWithCheckoutID:tokenID:cardPaymentBrand:CVV:error: instead.");

/**
 Creates an object representing a token transaction.
 
 @param checkoutID The checkout ID of the transaction. Must be not `nil` or empty.
 @param tokenID The identifier of the token that can be used to reference the token later.
 @param brand Payment method brand.
 @param error The error that occurred while validating payment parameters. See code attribute (`OPPErrorCode`) and `NSLocalizedDescription` to identify the reason of failure.
 @return Returns an object representing a token transaction, and `nil` if parameters are invalid.
 @warning **Deprecated:** Use `-initWithCheckoutID:tokenID:paymentBrand:error:` instead
 */
- (nullable instancetype)initWithCheckoutID:(NSString *)checkoutID tokenID:(NSString *)tokenID brand:(OPPPaymentParamsBrand)brand error:(NSError **)error DEPRECATED_MSG_ATTRIBUTE("- Use -initWithCheckoutID:tokenID:paymentBrand:error: instead.");

/**
 Creates an object representing a token transaction.
 
 @param checkoutID The checkout ID of the transaction. Must be not `nil` or empty.
 @param tokenID The identifier of the token that can be used to reference the token later.
 @param cardBrand The brand of the tokenized card.
 @param CVV The CVV code found on the card.
 @param error The error that occurred while validating payment parameters. See code attribute (`OPPErrorCode`) and `NSLocalizedDescription` to identify the reason of failure.
 @return Returns an object representing a token transaction, and `nil` if parameters are invalid.
 @warning **Deprecated:** Use `-initWithCheckoutID:tokenID:cardPaymentBrand:CVV:error:` instead
 */
- (nullable instancetype)initWithCheckoutID:(NSString *)checkoutID tokenID:(NSString *)tokenID cardBrand:(OPPPaymentParamsBrand)cardBrand CVV:(nullable NSString *)CVV error:(NSError **)error DEPRECATED_MSG_ATTRIBUTE("- Use -initWithCheckoutID:tokenID:cardPaymentBrand:CVV:error: instead.");

/**
 Checks if the card CVV is filled with sufficient data to perform a transaction.
 
 @param CVV The card security code or CVV.
 @param brand The brand of the tokenized card.
 @return YES if the card CVV length greater than 3 characters and less than 4 characters, it's also valid for `nil` value, because it's optional parameter.
 @warning **Deprecated:** Use `+isCvvValid:forPaymentBrand:` instead
 */
+ (BOOL)isCvvValid:(NSString *)CVV forBrand:(OPPPaymentParamsBrand)brand DEPRECATED_MSG_ATTRIBUTE("- Use +isCvvValid:forPaymentBrand: instead.");

/**
 Checks if the card CVV is filled with sufficient data to perform a transaction.
 
 @param CVV The card security code or CVV.
 @param paymentBrand The payment brand of the tokenized card.
 @return YES if the card CVV length greater than 3 characters and less than 4 characters, it's also valid for `nil` value, because it's optional parameter.
 @warning **Deprecated:** Use `+isCvvValid:` instead
 */
+ (BOOL)isCvvValid:(NSString *)CVV forPaymentBrand:(NSString *)paymentBrand DEPRECATED_MSG_ATTRIBUTE("- Use +isCvvValid: instead.");


@end
NS_ASSUME_NONNULL_END
