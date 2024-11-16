import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants/sizes.dart';
import '../loaders/shimmer_effect.dart';

class RoundedImage extends StatelessWidget {
  const RoundedImage({
    super.key,
    this.width,
    this.height,
    required this.imageUrl,
    this.applyImageRadius = false,
    this.noBottomRadius = false,
    this.border,
    this.backgroundColor = Colors.transparent,
    this.fit = BoxFit.cover,
    this.padding,
    this.isNetworkImage = false,
    this.onPressed,
    this.borderRadius = MAppSizes.md,
  });

  final double? width, height;
  final String imageUrl;

  final BoxBorder? border;
  final Color backgroundColor;
  final BoxFit? fit;
  final EdgeInsetsGeometry? padding;
  final bool isNetworkImage;
  final VoidCallback? onPressed;
  final bool applyImageRadius;
  final bool noBottomRadius;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        width: width,
        height: height,
        padding: padding,
        decoration: BoxDecoration(
          border: border,
          color: backgroundColor,
        ),
        child: isNetworkImage
            ? _buildCachedNetworkImage()
            : _buildAssetImage(),
      ),
    );
  }

  Widget _buildCachedNetworkImage() {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: fit,
      progressIndicatorBuilder: (context, url, downloadProgress) {
        return ShimmerEffect(width: width ?? 55, height: height ?? 55);
      },
      errorWidget: (context, url, error) {
        return const Icon(Icons.error);
      },
    );
  }

  Widget _buildAssetImage() {
    return Image(
      image: AssetImage(imageUrl),
      fit: fit,
      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) {
          return child;
        } else {
          return ShimmerEffect(width: width ?? 55, height: height ?? 55);
        }
      },
    );
  }
}
