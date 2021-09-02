import 'package:flutter/material.dart';
import 'base_validator.dart';

class RequiredValidator extends BaseValidator {
  @override
  String getMessage(BuildContext context) {
    return 'This field is required';
  }

  @override
  bool validate(String value) {
    return value != null && value.isNotEmpty;
  }
}