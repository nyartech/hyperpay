part of hyperpay;

// Regular experessions for each brand
// These expressions were chosen according to this article.
// https://uxplanet.org/streamlining-the-checkout-experience-4-4-6793dad81360

RegExp _visaRegExp = RegExp(r'^4[0-9]{12}(?:[0-9]{3})?$');
RegExp _mastercardRegExp = RegExp(r'^5[1-5][0-9]{5,}$');
RegExp _madaRegExpV = RegExp(
    r'4(0(0861|1757|7(197|395)|9201)|1(0685|7633|9593)|2(281(7|8|9)|8(331|67(1|2|3)))|3(1361|2328|4107|9954)|4(0(533|647|795)|5564|6(393|404|672))|5(5(036|708)|7865|8456)|6(2220|854(0|1|2|3))|8(301(0|1|2)|4783|609(4|5|6)|931(7|8|9))|93428)');
RegExp _madaRegExpM = RegExp(
    r'5(0(4300|8160)|13213|2(1076|4(130|514)|9(415|741))|3(0906|1095|2013|5(825|989)|6023|7767|9931)|4(3(085|357)|9760)|5(4180|7606|8848)|8(5265|8(8(4(5|6|7|8|9)|5(0|1))|98(2|3))|9(005|206)))|6(0(4906|5141)|36120)|9682(0(1|2|3|4|5|6|7|8|9)|1(0|1))');

extension DetectBrand on String {
  /// Detects a card brand from its number.
  ///
  /// Supports VISA, MasterCard, Mada
  BrandType get detectBrand {
    final cleanNumber = this.replaceAll(' ', '');

    bool _isMADA = _madaRegExpM.hasMatch(cleanNumber) ||
        _madaRegExpV.hasMatch(cleanNumber);
    bool _isVISA = _visaRegExp.hasMatch(cleanNumber);
    bool _isMASTERCARD = _mastercardRegExp.hasMatch(cleanNumber);

    if (_isMADA) {
      return BrandType.mada;
    } else if (_isVISA) {
      return BrandType.visa;
    } else if (_isMASTERCARD) {
      return BrandType.mastercard;
    } else {
      return BrandType.none;
    }
  }
}

extension BrandTypeExtension on BrandType {
  /// String representation for each card type as mentioned in HyperPay docs.
  ///
  /// https://wordpresshyperpay.docs.oppwa.com/reference/parameters
  String get asString {
    switch (this) {
      case BrandType.visa:
        return 'VISA';
      case BrandType.mastercard:
        return 'MASTER';
      case BrandType.mada:
        return 'MADA';
      default:
        return '';
    }
  }

  /// Get the entity ID of this brand based on merchant configuration.
  String? entityID(HyperpayConfig config) {
    String? _entityID = '';
    switch (this) {
      case BrandType.visa:
        _entityID = config.creditcardEntityID;
        break;
      case BrandType.mastercard:
        _entityID = config.creditcardEntityID;
        break;
      case BrandType.mada:
        _entityID = config.madaEntityID;
        break;

      default:
        _entityID = null;
    }
    return _entityID;
  }

  /// Match the string entered by user against RegExp rules
  /// for each card type.
  ///
  /// TODO: localize the messages.
  String? validateNumber(String number) {
    // Remove the white spaces inserted by formatters
    final cleanNumber = number.replaceAll(' ', '');

    switch (this) {
      case BrandType.visa:
        if (_visaRegExp.hasMatch(cleanNumber)) {
          return null;
        } else if (cleanNumber.isEmpty) {
          return "Required";
        } else {
          return "Inavlid VISA number";
        }
      case BrandType.mastercard:
        if (_mastercardRegExp.hasMatch(cleanNumber)) {
          return null;
        } else if (cleanNumber.isEmpty) {
          return "Required";
        } else {
          return "Inavlid MASTER CARD number";
        }
      case BrandType.mada:
        if (_madaRegExpV.hasMatch(cleanNumber) ||
            _madaRegExpM.hasMatch(cleanNumber)) {
          return null;
        } else if (cleanNumber.isEmpty) {
          return "Required";
        } else {
          return "Inavlid MADA number";
        }
      default:
        return "No brand provided";
    }
  }

  /// Maximum length of this card number
  ///
  /// https://wordpresshyperpay.docs.oppwa.com/reference/parameters
  int get maxLength {
    switch (this) {
      case BrandType.visa:
        return 16;
      case BrandType.mastercard:
        return 16;
      case BrandType.mada:
        return 16;
      default:
        return 19;
    }
  }
}
