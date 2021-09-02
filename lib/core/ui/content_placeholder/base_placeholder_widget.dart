import 'package:flutter/material.dart';
import 'package:journeyhazard/core/ui/styles/global_colors.dart';
//import 'package:shimmer/shimmer.dart';

class BasePlaceholderWidget extends StatelessWidget {
  final Widget child;
  final Color highlightColor;
  final Color baseColor;

  const BasePlaceholderWidget(
      {@required this.child, this.baseColor, this.highlightColor});

  @override
  Widget  build(BuildContext context) {
//    return Shimmer.fromColors(
//      baseColor: baseColor ?? GlobalColors.darkGrey,
//      highlightColor: highlightColor ?? GlobalColors.lightGrey,
//      child: child,
//    );
  }
}
