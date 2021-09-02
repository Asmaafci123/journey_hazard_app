import 'package:flutter/material.dart';
import 'package:journeyhazard/core/screen_utils/screen_utils.dart';
import 'package:journeyhazard/core/ui/styles/global_colors.dart';
import 'package:journeyhazard/core/ui/styles/global_styles.dart';
import 'package:journeyhazard/core/ui/widgets/vertical_padding.dart';

class TermsConditionsWidget extends StatelessWidget {
  final TermConditionsPageType pageType;

  const TermsConditionsWidget(
      {Key key, this.pageType = TermConditionsPageType.LOGIN_PAGE})
      : super(key: key);

  @override
  Widget  build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          TermConditionsPageType.REGISTER_PAGE == pageType
              ? Text(
                  'By creating account, you agree for our terms & conditions',
                  style: GlobalStyles.defaultTextStyle.copyWith(
                      color: GlobalColors.greyHint,
                      fontSize: ScreensHelper.scaleText(32)),
                )
              : Text(
                  'By signing in, you agree for our terms & conditions',
                  style: GlobalStyles.defaultTextStyle.copyWith(
                      color: GlobalColors.greyHint,
                      fontSize: ScreensHelper.scaleText(32)),
                ),
          VerticalPadding(
            percentage: 0.8,
          ),
          Text('Terms & Conditions',
              style: GlobalStyles.defaultTextStyle.copyWith(
                  fontSize: ScreensHelper.scaleText(32),
                  color: Colors.black54,
                  decoration: TextDecoration.underline)),
        ],
      ),
    );
  }
}

enum TermConditionsPageType { LOGIN_PAGE, REGISTER_PAGE }
