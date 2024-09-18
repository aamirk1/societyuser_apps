import 'package:flutter/material.dart';

class PasswordValidator with ChangeNotifier {
  String _errorMsg = '';

  String get errorMsg => _errorMsg;
  String _password = '';
  String get password => _password;
  String _confirmPassword = '';
  String get confirmPassword => _confirmPassword;

  bool _isValid = false;
  bool _hasUppercase = false;
  bool _hasLowercase = false;
  bool _hasNumber = false;
  bool _hasSpecialChar = false;
  String _errorMessage = '';
  bool get isValid => _isValid;
  bool get hasUppercase => _hasUppercase;
  bool get hasLowercase => _hasLowercase;
  bool get hasNumber => _hasNumber;
  bool get hasSpecialChar => _hasSpecialChar;
  String get errorMessage => _errorMessage;

  void validatePassword(String value) {
    _isValid = value.length >= 6;
    _hasUppercase = value.contains(RegExp(r'[A-Z]'));
    _hasLowercase = value.contains(RegExp(r'[a-z]'));
    _hasNumber = value.contains(RegExp(r'[0-9]'));
    _hasSpecialChar = value.contains(RegExp(r'[^A-Za-z0-9]'));

    _errorMessage = '''

${_isValid ? '' : 'Password must be at least 6 characters'}
${_hasUppercase ? '' : 'contain at least one uppercase letter'}
${_hasLowercase ? '' : 'one lowercase letter'}
${_hasNumber ? '' : 'one number, and'}
${_hasSpecialChar ? '' : 'one special character'}
''';

    notifyListeners();
  }

  void updatePassword(String value) {
    _password = value;
    notifyListeners();
  }

  void updateConfirmPassword(String value) {
    _confirmPassword = value;
    notifyListeners();
  }

  void updateErrorMessage(String message) {
    _errorMsg = message;
    notifyListeners();
  }
}
