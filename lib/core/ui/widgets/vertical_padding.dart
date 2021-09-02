import 'package:journeyhazard/core/screen_utils/screen_utils.dart';
import 'package:flutter/material.dart';

class VerticalPadding extends StatelessWidget {
  final double percentage;

  const VerticalPadding({Key key, @required this.percentage}) : super(key: key);

  @override
  Widget  build(BuildContext context) {
    return SizedBox(height: ScreensHelper.fromHeight(percentage));
  }
}
