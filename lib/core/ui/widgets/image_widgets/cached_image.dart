import 'package:cached_network_image/cached_network_image.dart';
import 'package:journeyhazard/core/ui/widgets/image_widgets/image_place_holder.dart';
import 'package:flutter/material.dart';

class CachedImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;
  final Widget placeholder;

  CachedImage({@required this.imageUrl, this.fit, this.placeholder});

  @override
  Widget  build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: fit ?? BoxFit.cover,
      placeholder: (BuildContext context, _) {
        return placeholder ?? ImagePlaceHolder();
      },
    );
  }
}
