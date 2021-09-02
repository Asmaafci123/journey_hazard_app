import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';

import 'base_placeholder_widget.dart';


// ignore: must_be_immutable
class TextPlaceholderWidget extends StatelessWidget {

  /// toWorkOn

  double width = ScreenUtil().setWidth(100) ;
  double height = ScreenUtil().setHeight(60) ;

  TextPlaceholderWidget({widthPercentage,heightPercentage}){
    if(widthPercentage!=null){
      width*=widthPercentage;
    }
    if(heightPercentage!=null){
      height*=heightPercentage;
    }
  }

  @override
  Widget  build(BuildContext context) {
    return BasePlaceholderWidget(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/2*0.01,vertical: 10),
        child: Container(width: this.width,height: this.height,decoration: BoxDecoration(color: Colors.red,borderRadius: BorderRadius.circular(2))),
      ),
    );
  }
}