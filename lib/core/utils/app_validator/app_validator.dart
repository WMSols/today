import 'package:today/core/utils/app_helper/app_helper.dart';

/// Central form and input validation. Use with [TextFormField.validator] and similar.
class AppValidator {
  AppValidator._();

  static final RegExp _emailPattern = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  static String? validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) {
      return 'Email is required';
    }
    if (!_emailPattern.hasMatch(email)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  /// Password rules: length, complexity, weak list. No spaces.
  static String? validatePassword(String? value) {
    if (AppHelper.isNullOrEmpty(value)) {
      return 'Password is required';
    }
    final s = value!;

    if (s.length < 8) {
      return 'Password must be at least 8 characters long';
    }

    if (s.length > 128) {
      return 'Password is too long (max 128 characters)';
    }

    if (s.contains(' ')) {
      return 'Password cannot contain spaces';
    }

    const weakPasswords = [
      'password',
      '123456',
      '12345678',
      'qwerty',
      'abc123',
      'password123',
      'password1',
      '123456789',
    ];
    if (weakPasswords.contains(s.toLowerCase())) {
      return 'This password is too common. Please choose a stronger one';
    }

    if (s.split('').every((char) => char == s[0])) {
      return 'Password cannot be all the same character';
    }

    if (RegExp(r'^\d+$').hasMatch(s)) {
      return 'Password should contain letters, not just numbers';
    }

    if (RegExp(r'^[a-zA-Z]+$').hasMatch(s)) {
      return 'For better security, add numbers or special characters';
    }

    if (!RegExp(r'[A-Z]').hasMatch(s)) {
      return 'Password must contain at least one uppercase letter';
    }

    if (!RegExp(r'[a-z]').hasMatch(s)) {
      return 'Password must contain at least one lowercase letter';
    }

    if (!RegExp(r'[0-9]').hasMatch(s)) {
      return 'Password must contain at least one number';
    }

    if (!RegExp(r'[!@#$%^&*()_+\-=\[\]{};:"\\|,.<>/?]').hasMatch(s)) {
      return 'Password must contain at least one special character (!@#\$%^&*...)';
    }

    return null;
  }

  /// Same rules as [validatePassword], then must equal [otherPassword].
  static String? validateConfirmPassword(String? value, String otherPassword) {
    final passwordError = validatePassword(value);
    if (passwordError != null) {
      return passwordError;
    }
    if ((value ?? '') != otherPassword) {
      return 'Passwords do not match';
    }
    return null;
  }

  /// Phone number validation with international format support.
  static String? validatePhone(String? value) {
    if (AppHelper.isNullOrEmpty(value)) {
      return 'Phone number is required';
    }

    final trimmedValue = value!.trim();

    if (trimmedValue.isEmpty) {
      return 'Phone number cannot be only spaces';
    }

    final cleanedPhone = trimmedValue.replaceAll(RegExp(r'[\s\-\(\)\+]'), '');

    if (!RegExp(r'^\d+$').hasMatch(cleanedPhone)) {
      return 'Phone number can only contain digits, spaces, dashes, parentheses, and +';
    }

    if (cleanedPhone.length < 7) {
      return 'Phone number must be at least 7 digits';
    }

    if (cleanedPhone.length > 15) {
      return 'Phone number is too long (maximum 15 digits)';
    }

    if (cleanedPhone.split('').every((char) => char == cleanedPhone[0])) {
      return 'Please enter a valid phone number';
    }

    return null;
  }

  /// Required non-empty field (after trim).
  static String? validateRequired(String? value, [String? fieldName]) {
    if (AppHelper.isNullOrEmpty(value)) {
      return '${fieldName ?? 'This field'} is required';
    }
    return null;
  }
}
