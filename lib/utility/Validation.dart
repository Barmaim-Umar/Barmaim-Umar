
class Validation{
  static String mobileNumber(String value){
    if(value.length>10){
      return value.substring(0,10).replaceAll(RegExp(r'[^\w\s]+'),'');
    }
    return value.replaceAll(RegExp(r'[^\w\s]+'),'');
  }

  static String loanTenure(String value){
    if(value.length>2){
      return value.substring(0,2).replaceAll(RegExp(r'[^\w\s]+'),'');
    }
    return value.replaceAll(RegExp(r'[^\w\s]+'),'');
  }

  static String amountLimit(String value){
    if(value.length>8){
      return value.substring(0,8).replaceAll(RegExp(r'[^\w\s]+'),'');
    }
    return value.replaceAll(RegExp(r'[^\w\s]+'),'');
  }

  static String accountNumberLimit(String value){
    if(value.length>18){
      return value.substring(0,18).replaceAll(RegExp(r'[^\w\s]+'),'');
    }
    return value.replaceAll(RegExp(r'[^\w\s]+'),'');
  }

  static String limit(String value){
    if(value.length>14){
      return value.substring(0,14).replaceAll(RegExp(r'[^\w\s]+'),'');
    }
    return value.replaceAll(RegExp(r'[^\w\s]+'),'');
  }

  static String penaltyAmount(String value){
    if(value.length>6){
      return value.substring(0,6).replaceAll(RegExp(r'[^\w\s]+'),'');
    }
    return value.replaceAll(RegExp(r'[^\w\s]+'),'');
  }

  static String pinCode(String value){
    if(value.length>6){
      return value.substring(0,6).replaceAll(RegExp(r'[^\w\s]+'),'');
    }
    return value.replaceAll(RegExp(r'[^\w\s]+'),'');

  }

  static String aadhaarNumber(String value){
    if(value.length>12){
      return value.substring(0,12).replaceAll(RegExp(r'[^\w\s]+'),'');
    }
    return value.replaceAll(RegExp(r'[^\w\s]+'),'');

  }

  static String panCardNo(String value){
    if(value.length>10){
      return value.substring(0,10).replaceAll(RegExp(r'[^\w\s]+'),'').toUpperCase();
    }
    return value.replaceAll(RegExp(r'[^\w\s]+'),'').toUpperCase();
  }

  static String ifscCode(String value){
    if(value.length>11){
      return value.substring(0,11).replaceAll(RegExp(r'[^\w\s]+'),'').toUpperCase();
    }
    return value.replaceAll(RegExp(r'[^\w\s]+'),'').toUpperCase();
  }

  static String CINNo(String value){
    if(value.length>21){
      return value.substring(0,21).replaceAll(RegExp(r'[^\w\s]+'),'');
    }
    return value.replaceAll(RegExp(r'[^\w\s]+'),'');
  }

  static String regexSchemeCode(String value){
    if(value.length>10){
      return value.substring(0,8).replaceAll(RegExp(r'[^\w\s]+'),'');
    }
    return value.replaceAll(RegExp(r'[^\w\s]+'),'');
  }

  static String GSTNo(String value){
    if(value.length>15){
      return value.substring(0,15).replaceAll(RegExp(r'[^\w\s]+'),'').toUpperCase();
    }
    return value.replaceAll(RegExp(r'[^\w\s]+'),'').toUpperCase();
  }

  static String name(String value){
    if(!RegExp(r"^[a-zA-Z]+$").hasMatch(value)){
      return value.replaceAll(RegExp(r'[^\w\s]+'),'');
    }
    return value.replaceAll(RegExp(r'[^\w\s]+'),'');
  }

  static String age(String value){
    if(value.length>3){
      return value.substring(0,3).replaceAll(RegExp(r'[^\w\s]+'),'');
    }
    return value.replaceAll(RegExp(r'[^\w\s]+'),'');
  }

  /// Date validation ==========================
  /// Day Validation
  static String dateDay(String value){
    if(value.length>2){
      return value.substring(0,2).replaceAll(RegExp(r'[^\w\s]+'),'');
    }
    return value.replaceAll(RegExp(r'[^\w\s]+'),'');
  }

  /// Month Validation
  static String dateMonth(String value){
    if(value.length>2){
      return value.substring(0,2).replaceAll(RegExp(r'[^\w\s]+'),'');
    }
    return value.replaceAll(RegExp(r'[^\w\s]+'),'');
  }
  /// Month Validation
  static String dateYear(String value){
    if(value.length>4){
      return value.substring(0,4).replaceAll(RegExp(r'[^\w\s]+'),'');
    }
    return value.replaceAll(RegExp(r'[^\w\s]+'),'');
  }
}