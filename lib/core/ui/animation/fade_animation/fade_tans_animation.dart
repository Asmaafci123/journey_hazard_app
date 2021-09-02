import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class FadeTransAnimation extends StatelessWidget {
  final Widget child;
  final int delayInMillisecond;

  final AxisDirection direction;

  final double translateYDistance;

  FadeTransAnimation(
      {@required this.delayInMillisecond,
      @required this.child,
      this.direction = AxisDirection.up,
      this.translateYDistance=30});

  @override
  Widget  build(BuildContext context) {
    final tween = MultiTrackTween([
      Track("opacity").add(Duration(milliseconds: 500), Tween(begin: 0.0, end: 1.0)),
      Track("translateY").add(
          Duration(milliseconds: 500),
          this.direction == AxisDirection.up
              ? Tween(begin: -translateYDistance, end: 0.0)
              : (this.direction == AxisDirection.down
                  ? Tween(begin: translateYDistance, end: 0.0)
                  : (this.direction == AxisDirection.right
                      ? Tween(begin: 0.0, end: translateYDistance)
                      : Tween(begin: 0.0, end: -translateYDistance))),
          curve: Curves.easeOut)
    ]);

    return ControlledAnimation(
      delay: Duration(milliseconds: delayInMillisecond),
      duration: tween.duration,
      tween: tween,
      child: child,
      builderWithChild: (context, child, animation) => Opacity(
        opacity: animation["opacity"],
        child: Transform.translate(offset: Offset(0, animation["translateY"]), child: child),
      ),
    );
  }
}
