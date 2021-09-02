import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FileAvatar extends StatelessWidget {
  final double radius;
  final File image;

  const FileAvatar({
    Key key,
    @required this.radius,
    @required this.image,
  })  : assert(radius != null),
        assert(image != null),
        super(key: key);

  @override
  Widget  build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(radius * 2),
      height: ScreenUtil().setWidth(radius * 2),
      child: ClipOval(
        child: Image.file(
          image,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
