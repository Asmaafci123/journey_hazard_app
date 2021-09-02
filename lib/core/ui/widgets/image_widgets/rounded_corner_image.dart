import 'package:journeyhazard/core/ui/widgets/image_widgets/cached_image.dart';
import 'package:flutter/material.dart';

class RoundedCornerImage extends StatelessWidget {
  /// toWorkOn : set default value for the cornerRadius
  /// toWorkOn : add shadow
  final double cornerRadius;
  final double width;
  final double height;
  final String image;
  final Widget placeHolder;
  final bool isNetworkImage;

  const RoundedCornerImage({
    @required this.cornerRadius,
    @required this.image,
    this.width,
    this.height,
    this.placeHolder,
    this.isNetworkImage = true,
  });

  @override
  Widget  build(BuildContext context) {
    return Container(
      width: this.width,
      height: this.height,
      child: ClipRRect(
          borderRadius: BorderRadius.circular(cornerRadius),
          child: isNetworkImage == null || isNetworkImage == true
              ? CachedImage(
                  imageUrl: image,
                  placeholder: placeHolder,
                )
              : Image.asset(
                  image,
                  fit: BoxFit.cover,
                )),
    );
  }
}
