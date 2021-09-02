import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:journeyhazard/core/screen_utils/screen_utils.dart';
import 'package:journeyhazard/core/ui/styles/global_colors.dart';

class RoundedAnimatedButton extends StatefulWidget {
  final String text;
  final Color color;
  final Image leadingImage;
  final Color textColor;
  final bool isLoading;

  final VoidCallback onPressed;

  final double width;

  final double borderRadius;

  final BorderSide borderSide;

  const RoundedAnimatedButton(
      {Key key,
      @required this.text,
      this.color,
      this.leadingImage,
      this.textColor,
      this.isLoading = false,
      this.onPressed,
      this.width,
      this.borderRadius,
      this.borderSide})
      : super(key: key);

  @override
  _RoundedAnimatedButtonState createState() => _RoundedAnimatedButtonState();
}

class _RoundedAnimatedButtonState extends State<RoundedAnimatedButton> {
  Duration _animationDuration = Duration(seconds: 1);

  @override
  Widget  build(BuildContext context) {
    return AnimatedSwitcher(
      duration: _animationDuration,
      child: _getAnimatedWidget(),
//      transitionBuilder: (Widget child, Animation<double> animation) {
//        return ScaleTransition(
//          scale: animation,
//          child: child,
//        );
//      },
    );
  }

  _getAnimatedWidget() {
    if (widget.isLoading)
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Center(child: Container(child: CircularProgressIndicator())),
        ],
      );
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(0.0)),
      child: AnimatedContainer(
        duration: _animationDuration,
        width: widget.isLoading
            ? ScreenUtil().setHeight(130)
            : this.widget.width ??
                (MediaQuery.of(context).size.width -
                    ScreenUtil().setWidth(170)),
        height: ScreensHelper.fromHeight(6.4),
        child: FlatButton(
          onPressed: () {
            widget.onPressed();
          },
          shape: RoundedRectangleBorder(
              side: widget.borderSide ?? BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(widget.isLoading
                  ? ScreenUtil().setHeight(130)
                  : (widget.borderRadius ?? ScreensHelper.fromWidth(1.5)))),
          color: widget.color ?? GlobalColors.primaryOrange,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Opacity(opacity: 0.0, child: widget.leadingImage ?? Container()),
              Center(
                child: Text(
                  widget.text,
                  style: TextStyle(
                      color: widget.textColor ?? Colors.white,
                      fontFamily: 'Manjari',
                      fontSize: ScreensHelper.scaleText(45)),
                ),
              ),
              widget.leadingImage ?? Container(),
            ],
          ),
        ),
      ),
    );
  }
}
