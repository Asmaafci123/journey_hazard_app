import 'package:flutter/material.dart';
import '../validators/base_validator.dart';

class VerificationCodeValidator extends BaseValidator {
  @override
  String getMessage(BuildContext context) {
    return 'Invalid verification code';
  }

  @override
  bool validate(String value) {
    return value != null && value.isNotEmpty && value.length == 5;
  }
}