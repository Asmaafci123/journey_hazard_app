import 'dart:ui';
import 'package:flutter/material.dart';

class BlurredBackgroundAssetImage extends StatelessWidget {

  final String imagePath;
  final Widget child;


  BlurredBackgroundAssetImage({Key key,@required this.imagePath,@required this.child}):super(key:key);

  @override
  Widget  build(BuildContext context) {
    return Stack(
      children: <Widget>[

        /// background image
        Container(child: Image.asset(this.imagePath,
          fit: BoxFit.cover,
          height:  MediaQuery.of(context).size.height,),),

        /// blur layer
        Positioned.fill(child: BackdropFilter(
          filter: ImageFilter.blur(sigmaY: 4,sigmaX: 4),
          child: Container(
            color: Colors.black.withOpacity(0),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),
        )),

        /// child
        Positioned(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: this.child??Container(),
        )
      ],
    );
  }
}
