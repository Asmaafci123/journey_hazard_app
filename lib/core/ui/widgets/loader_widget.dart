import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:journeyhazard/core/screen_utils/screen_utils.dart';
import 'package:journeyhazard/core/ui/styles/global_colors.dart';
import 'package:journeyhazard/core/ui/widgets/vertical_padding.dart';

class LoaderWidget extends StatelessWidget {
  final String text;

  const LoaderWidget({Key key, this.text}) : super(key: key);


  @override
  Widget  build(BuildContext context) {
    return Column(
      children: [
        SpinKitWave(color: GlobalColors.primaryOrange,
          size: ScreensHelper.fromWidth(7),
          type: SpinKitWaveType.start,),
        VerticalPadding(percentage: 1.5,),
        Text('$text')
      ],
    );
  }
}
