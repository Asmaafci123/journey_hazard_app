import 'package:flutter/material.dart';
import 'base_validator.dart';

class MinLengthValidator extends BaseValidator {
  final int minLength;

  MinLengthValidator({@required this.minLength});

  @override
  String getMessage(BuildContext context) {
    return 'This field should minimum length of '
        '$minLength '
        'characters';
  }

  @override
  bool validate(String value) {
    return value.length >= minLength;
  }
}
