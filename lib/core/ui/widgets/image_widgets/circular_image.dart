import 'package:journeyhazard/core/ui/widgets/image_widgets/cached_image.dart';
import 'package:flutter/material.dart';

class CircularImage extends StatelessWidget {
  final double radius;
  final String imageUrl;
  final bool isNetworkImage;
  final Widget placeHolder;

  /// toWorkOn : add shadow

  const CircularImage({
    Key key,
    @required this.radius,
    @required this.imageUrl,
    this.isNetworkImage = true,
    this.placeHolder,
  })  : assert(radius != null),
        assert(imageUrl != null),
        super(key: key);

  @override
  Widget  build(BuildContext context) {
    return Container(
      width: radius,
      height: radius,
      child: ClipOval(
        child: isNetworkImage
            ? CachedImage(
                imageUrl: imageUrl,
                placeholder: placeHolder,
              )
            : Image.asset(
                imageUrl,
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}
