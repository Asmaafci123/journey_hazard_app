import 'package:journeyhazard/core/screen_utils/screen_utils.dart';
import 'package:journeyhazard/core/ui/widgets/vertical_padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EmptyContentWidget extends StatelessWidget {
  final String message;
  final String svgImagePath;
  final double width;
  final double fontSize;

  const EmptyContentWidget(
      {Key key,
      @required this.message,
      this.svgImagePath,
      this.width,
      this.fontSize})
      : super(key: key);

  @override
  Widget  build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              this.svgImagePath == null
                  ? Container()
                  : SvgPicture.asset(
                      this.svgImagePath.isEmpty
                          ? 'assets/images/empty1.svg'
                          : this.svgImagePath,
                      width: this.width ?? ScreensHelper.fromWidth(50.0),
                    )
            ],
          ),
          VerticalPadding(
            percentage: 4,
          ),
          Text(
            this.message ?? 'No Data',
            style: TextStyle(
                fontSize: this.fontSize ?? ScreensHelper.scaleText(42)),
          )
        ],
      ),
    );
  }
}
