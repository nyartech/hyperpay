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

DEPRECATED_MSG_ATTRIBUTE("The OPPPaymentParamsBrand class is formally deprecated. Use string values for the payment brands.")

/**
 An enumeration for the various payment brands.
 
 @warning **Deprecated:** The `OPPPaymentParamsBrand` class is formally deprecated in 1.4.0. Use string values for the payment brands.
 */
typedef NS_ENUM(NSInteger, OPPPaymentParamsBrand) {
    /// VISA card payment brand.
    OPPPaymentParamsBrandVISA DEPRECATED_MSG_ATTRIBUTE("The attribute is no longer used. Please use string value \"VISA\" instead of."),
    /// MasterCard payment brand.
    OPPPaymentParamsBrandMasterCard DEPRECATED_MSG_ATTRIBUTE("The attribute is no longer used. Please use string value \"MASTER\" instead of."),
    /// American Express card brand.
    OPPPaymentParamsBrandAMEX DEPRECATED_MSG_ATTRIBUTE("The attribute is no longer used. Please use string value \"AMEX\" instead of."),
    /// Diners Club card brand.
    OPPPaymentParamsBrandDinersClub DEPRECATED_MSG_ATTRIBUTE("The attribute is no longer used. Please use string value \"DINERS\" instead of."),
    /// Discover card brand.
    OPPPaymentParamsBrandDiscover DEPRECATED_MSG_ATTRIBUTE("The attribute is no longer used. Please use string value \"DISCOVER\" instead of."),
    /// UnionPay (ExpressPay) card brand.
    OPPPaymentParamsBrandUnionPay DEPRECATED_MSG_ATTRIBUTE("The attribute is no longer used. Please use string value \"UNIONPAY\" instead of."),
    /// JCB card brand.
    OPPPaymentParamsBrandJCB DEPRECATED_MSG_ATTRIBUTE("The attribute is no longer used. Please use string value \"JCB\" instead of."),
    
    /// SEPA direct debit payment brand.
    OPPPaymentParamsBrandDirectDebitSEPA DEPRECATED_MSG_ATTRIBUTE("The attribute is no longer used. Please use string value \"DIRECTDEBIT_SEPA\" instead of."),
    /// SOFORT banking payment brand.
    OPPPaymentParamsBrandSOFORTBanking DEPRECATED_MSG_ATTRIBUTE("The attribute is no longer used. Please use string value \"SOFORTUEBERWEISUNG\" instead of."),
    /// BOLETO payment brand.
    OPPPaymentParamsBrandBOLETO DEPRECATED_MSG_ATTRIBUTE("The attribute is no longer used. Please use string value \"BOLETO\" instead of."),
    /// IDEAL payment brand.
    OPPPaymentParamsBrandIDEAL DEPRECATED_MSG_ATTRIBUTE("The attribute is no longer used. Please use string value \"IDEAL\" instead of."),
    
    /// Apple pay payment brand.
    OPPPaymentParamsBrandApplePay DEPRECATED_MSG_ATTRIBUTE("The attribute is no longer used. Please use string value \"APPLEPAY\" instead of."),
    
    /// PayPal payment brand.
    OPPPaymentParamsBrandPayPal DEPRECATED_MSG_ATTRIBUTE("The attribute is no longer used. Please use string value \"PAYPAL\" instead of."),
    /// China UnionPay brand.
    OPPPaymentParamsBrandChinaUnionPay DEPRECATED_MSG_ATTRIBUTE("The attribute is no longer used. Please use string value \"CHINAUNIONPAY\" instead of."),
    
    /// Alipay payment brand.
    OPPPaymentParamsBrandAlipay DEPRECATED_MSG_ATTRIBUTE("The attribute is no longer used. Please use string value \"ALIPAY\" instead of."),
    
    /// Unsupported payment brand.
    OPPPaymentParamsBrandUnknown DEPRECATED_MSG_ATTRIBUTE("The attribute is no longer used.")
};
