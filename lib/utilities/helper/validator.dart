class Validator {
  String message = "";

  static bool _validateMobile(String value) {
    String pattern = r'^[6-9]\d{9}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(value);
  }

  // ? Its no more required as per client requirement
  /*  static bool _validateAddress(String address) {
    final pattern = r"^[A-Za-z0-9\u0900-\u097F\s!#$%@^&*()_\-+=\{\}\[\]:\;',.<>\/?±§|\\]+$";
    return RegExp(pattern).hasMatch(address);
  }*/

  static bool _validateOtp(String otp) {
    String pattern = r'^\d{4}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(otp);
  }

  static bool _validateEmail(String email) {
    final pattern =
        r'^[a-zA-Z0-9._%+-]+'
        r'@[a-zA-Z0-9.-]+'
        r'\.[a-zA-Z]{2,}$';

    final regExp = RegExp(pattern);
    return regExp.hasMatch(email);
  }

  static bool _validatePinCode(String pin) {
    String pattern = r'^\d{6}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(pin);
  }

  static bool _validateName(String name) {
    /// English + Marathi (Devanagari) + space + dot
    final pattern = r'^[A-Za-z\u0900-\u097F .,:(){}-]+$';
    final regExp = RegExp(pattern);
    return regExp.hasMatch(name);
  }

  static String? validateUrl(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    final pattern =
        r'^(https?:\/\/)'
        r'([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}'
        r'(\/[^\s]*)?$';

    final regExp = RegExp(pattern);

    if (!regExp.hasMatch(value.trim())) {
      return 'Please enter a valid $fieldName (https://...)';
    }
    return null;
  }

  static bool _validateDate(String date) {
    final reg = RegExp(r'^(\d{4})-(\d{2})-(\d{2})$');
    final match = reg.firstMatch(date);

    if (match == null) return false;

    final year = int.parse(match.group(1)!);
    final month = int.parse(match.group(2)!);
    final day = int.parse(match.group(3)!);

    if (month < 1 || month > 12) return false;

    final daysInMonth = <int>[31, _isLeapYear(year) ? 29 : 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

    return day >= 1 && day <= daysInMonth[month - 1];
  }

  static bool _isLeapYear(int year) {
    if (year % 400 == 0) return true;
    if (year % 100 == 0) return false;
    return year % 4 == 0;
  }

  static String? detectMaliciousInput(String value) {
    final v = value.toLowerCase();

    // malicious characters
    final charPattern = RegExp(r'[<>`~^|\\{}[\];$.:",%=]');
    if (charPattern.hasMatch(v)) {
      return "Special characters like < > { } [ ] | are not allowed";
    }

    // HTML tags
    final htmlPattern = RegExp(r'<[^>]*>', caseSensitive: false);
    if (htmlPattern.hasMatch(v)) {
      return "HTML tags are not allowed";
    }

    // XSS keywords
    final xssPattern = RegExp(r'(javascript:|onerror\s*=|onload\s*=|alert\s*\(|document\.|window\.)', caseSensitive: false);
    if (xssPattern.hasMatch(v)) {
      return "Script or XSS content is not allowed";
    }

    // SQL injection keywords
    final sqlPattern = RegExp(
      r'(select\s+.*\s+from|insert\s+into|delete\s+from|update\s+.*\s+set|drop\s+table|union\s+select|or\s+1=1|--|;)',
      caseSensitive: false,
    );
    if (sqlPattern.hasMatch(v)) {
      return "SQL keywords are not allowed";
    }

    return null;
  }

  // ---------------- PUBLIC VALIDATOR ----------------
  static String? validate(String value, String fieldName) {
    final field = fieldName.toLowerCase();
    final v = value.trim();

    // ---------------- EMAIL ----------------
    if (field.contains("email")) {
      if (v.isEmpty) return 'Enter email address';
      if (!_validateEmail(v)) return 'Enter a valid email address';
      return null; // stop further validation
    }

    if (field.contains("url") || field.contains("website") || field.contains("link")) {
      return validateUrl(v, fieldName);
    }

    if (field.contains("address")) {
      if (v.isEmpty) return 'Please enter your address';
      return null;
    }

    // Facebook
    if (field.contains("facebook")) {
      final reg = RegExp(r'^[a-zA-Z0-9.]{1,50}$');
      if (v.isNotEmpty && !reg.hasMatch(v)) {
        return "Invalid Facebook username";
      }
      return null;
    }

    // Instagram
    if (field.contains("instagram")) {
      final reg = RegExp(r'^[a-zA-Z0-9._]{1,30}$');
      if (v.isNotEmpty && !reg.hasMatch(v)) {
        return "Invalid Instagram username";
      }
      return null;
    }

    // Twitter / X
    if (field.contains("twitter")) {
      final reg = RegExp(r'^[a-zA-Z0-9_]{1,15}$');
      if (v.isNotEmpty && !reg.hasMatch(v)) {
        return "Invalid Twitter/X username";
      }
      return null;
    }

    // ---------------- MOBILE ----------------
    if (field.contains("mobile")) {
      if (v.isEmpty) return 'Enter your mobile number';
      if (!Validator._validateMobile(v)) return 'Enter a valid mobile number';
      if (v.length != 10) return 'Mobile number must be 10 digits';
    }

    // ---------------- NAME ----------------
    if (field.contains("name")) {
      if (!_validateName(v)) return "Please enter $fieldName";
    }

    // ---------------- Email ----------------
    if (field.contains("email")) {
      if (v.isEmpty) return 'Enter email address';
      if (!_validateEmail(v)) return 'Enter a valid email address';
    }

    // ---------------- OTP ----------------
    if (field.contains("otp")) {
      if (!_validateOtp(v)) return "Enter a valid 4-digit OTP";
    }

    // ---------------- PIN ----------------
    if (field.contains("pin")) {
      if (!_validatePinCode(v)) return "Enter a valid 6-digit Pin Code";
    }

    // ---------------- ADDRESS ----------------
    if (field.contains("address") && !field.contains("email")) {
      if (v.isEmpty) return 'Please enter your address.';
    }

    if (field.contains("date")) {
      if (v.isEmpty) return 'Please select date';
      if (!_validateDate(v)) return 'Enter a valid date (DD/MM/YYYY)';
    }

    // ================= SOCIAL =================
    // Facebook
    if (field.contains("facebook")) {
      final reg = RegExp(r'^[a-zA-Z0-9.]{1,50}$');
      if (v.isNotEmpty && !reg.hasMatch(v)) {
        return "Invalid Facebook username";
      }
    }

    // Instagram
    if (field.contains("instagram")) {
      final reg = RegExp(r'^[a-zA-Z0-9._]{1,30}$');
      if (v.isNotEmpty && !reg.hasMatch(v)) {
        return "Invalid Instagram username";
      }
    }

    // Twitter / X
    if (field.contains("twitter")) {
      final reg = RegExp(r'^[a-zA-Z0-9_]{1,15}$');
      if (v.isNotEmpty && !reg.hasMatch(v)) {
        return "Invalid Twitter/X username";
      }
    }

    return null;
  }
}
