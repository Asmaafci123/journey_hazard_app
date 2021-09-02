import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:journeyhazard/core/screen_utils/screen_utils.dart';

class LogoWidget extends StatelessWidget {
  final double width;

  const LogoWidget({Key key, this.width}) : super(key: key);
  @override
  Widget  build(BuildContext context) {
    return Container(
      child: SvgPicture.asset(
        "assets/pidgelogo.svg",
        width: width,
      ),
    );
  }
}
