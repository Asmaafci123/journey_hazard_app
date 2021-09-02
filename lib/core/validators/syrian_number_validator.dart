import 'package:flutter/material.dart';
import '../validators/base_validator.dart';

class SyrianNumberValidator extends BaseValidator {
  @override
  String getMessage(BuildContext context) {
    return 'Invalid phone number';
  }

  @override
  bool validate(String value) {
    return value != null &&
        value.isNotEmpty &&
        (value.startsWith('09') && value.length == 10);
  }
}
