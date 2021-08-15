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

__deprecated_msg("The OPPCheckoutPaymentMethod class is formally deprecated. Use string values for the payment brands.")
/**
 An enumeration for the possible payment methods.
 
 @warning **Deprecated:** The `OPPCheckoutPaymentMethod` class is formally deprecated. Use string values for the payment brands.
 */
typedef NS_ENUM(NSInteger, OPPCheckoutPaymentMethod) {
    /// VISA payment system.
    OPPCheckoutPaymentMethodVISA __deprecated_enum_msg("The attribute is no longer used. Please use string value \"VISA\" instead of."),
    /// MasterCard payment system.
    OPPCheckoutPaymentMethodMasterCard __deprecated_enum_msg("The attribute is no longer used. Please use string value \"MASTER\" instead of."),
    /// AMEX payment system.
    OPPCheckoutPaymentMethodAMEX __deprecated_enum_msg("The attribute is no longer used. Please use string value \"AMEX\" instead of."),
    /// Diners Club payment system.
    OPPCheckoutPaymentMethodDinersClub __deprecated_enum_msg("The attribute is no longer used. Please use string value \"DINERS\" instead of."),
    /// Discover payment system.
    OPPCheckoutPaymentMethodDiscover __deprecated_enum_msg("The attribute is no longer used. Please use string value \"DISCOVER\" instead of."),
    /// UnionPay payment system.
    OPPCheckoutPaymentMethodUnionPay __deprecated_enum_msg("The attribute is no longer used. Please use string value \"UNIONPAY\" instead of."),
    /// JCB payment system.
    OPPCheckoutPaymentMethodJCB __deprecated_enum_msg("The attribute is no longer used. Please use string value \"JCB\" instead of."),
    /// SEPA Direct Debit payment system.
    OPPCheckoutPaymentMethodDirectDebitSEPA __deprecated_enum_msg("The attribute is no longer used. Please use string value \"DIRECTDEBIT_SEPA\" instead of."),
    /// BOLETO payment system.
    OPPCheckoutPaymentMethodBOLETO __deprecated_enum_msg("The attribute is no longer used. Please use string value \"BOLETO\" instead of."),
    /// Apple Pay payment system.
    OPPCheckoutPaymentMethodApplePay __deprecated_enum_msg("The attribute is no longer used. Please use string value \"APPLEPAY\" instead of."),
    /// SOFORT Banking payment system.
    OPPCheckoutPaymentMethodSOFORTBanking __deprecated_enum_msg("The attribute is no longer used. Please use string value \"SOFORTUEBERWEISUNG\" instead of."),
    /// PayPal payment system.
    OPPCheckoutPaymentMethodPayPal __deprecated_enum_msg("The attribute is no longer used. Please use string value \"PAYPAL\" instead of."),
    /// Alipay payment system.
    OPPCheckoutPaymentMethodAlipay __deprecated_enum_msg("The attribute is no longer used. Please use string value \"ALIPAY\" instead of."),
    /// China UnionPay (UPOP) payment system.
    OPPCheckoutPaymentMethodChinaUnionPay __deprecated_enum_msg("The attribute is no longer used. Please use string value \"CHINAUNIONPAY\" instead of."),
    /// IDEAL payment system.
    OPPCheckoutPaymentMethodIDEAL __deprecated_enum_msg("The attribute is no longer used. Please use string value \"IDEAL\" instead of."),
    /// Unsupported payment system.
    OPPCheckoutPaymentMethodUnsupported __deprecated_enum_msg("The attribute is no longer used.")
};
