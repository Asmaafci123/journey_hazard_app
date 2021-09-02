import 'package:flutter/material.dart';
import 'base_validator.dart';

class MatchValidator extends BaseValidator {
  String value;

  MatchValidator({@required this.value}) : assert(value != null);

  @override
  String getMessage(BuildContext context) {
    return 'No Match';
  }

  @override
  bool validate(String value) {
    print('const value: ${this.value}');
    print('var value: $value');
    return value == this.value;
  }
}
