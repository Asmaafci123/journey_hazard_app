import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:journeyhazard/core//screen_utils/screen_utils.dart';
import 'package:journeyhazard/core/constants.dart';

class LogoWidget extends StatelessWidget {
  final double width;

  const LogoWidget({Key key, this.width}) : super(key: key);
  @override
  Widget  build(BuildContext context) {
    return Container(
//      child:
//      SvgPicture.asset(
//        SHHNATY_LOGO,
//        width: width,
//      ),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(SHHNATY_LOGO),
          fit: BoxFit.contain,
         // colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.darken),
        ),
      ),
    );
  }
}
