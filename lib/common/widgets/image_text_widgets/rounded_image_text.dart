import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/constants/text_strings.dart';
import '../../../utils/helpers/helper_functions.dart';

class RoundedImageText extends StatelessWidget {
  const RoundedImageText({
    super.key,
    this.width,
    this.height,
    required this.imageUrl,
    this.applyImageRadius = false,
    this.border,
    this.backgroundColor = Colors.transparent,
    this.fit = BoxFit.contain,
    this.padding,
    this.isNetworkImage = false,
    this.onPressed,
    this.borderRadius = MAppSizes.md,
    required this.title,
    required this.subtitle,
  });

  final double? width, height;
  final String imageUrl;
  final bool applyImageRadius;
  final BoxBorder? border;
  final Color backgroundColor;
  final BoxFit? fit;
  final EdgeInsetsGeometry? padding;
  final bool isNetworkImage;
  final VoidCallback? onPressed;
  final double borderRadius;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        padding: padding,
        decoration: BoxDecoration(
          border: border,
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Stack(
          children: [
            SizedBox(
              width: MAppHelperFunctions.screenWidth(),
              height: MAppHelperFunctions.screenHeight() * 0.4,
              child: ClipRRect(
                borderRadius: applyImageRadius
                    ? BorderRadius.circular(borderRadius)
                    : BorderRadius.zero,
                child: isNetworkImage
                    ? CachedNetworkImage(
                        fit: fit,
                        imageUrl: imageUrl,
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      )
                    : Image(
                        fit: fit,
                        image: AssetImage(imageUrl),
                      ),
              ),
            ),
            Positioned(
              top: MAppSizes.xxl,
              left: MAppSizes.lg,
              child: SizedBox(
                width: 300,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title.toUpperCase(),
                      style:
                          Theme.of(context).textTheme.headlineLarge!.copyWith(
                        color: MAppColors.textWhite,
                        height: 1,
                        shadows: [
                          Shadow(
                            offset: const Offset(0, 0),
                            color: MAppColors.black.withOpacity(0.5),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: MAppSizes.md),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: MAppColors.textWhite,
                        height: 1,
                        shadows: [
                          Shadow(
                            offset: const Offset(0, 0),
                            color: MAppColors.black.withOpacity(0.5),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: MAppSizes.md),
            if (onPressed != null)
              Positioned(
                bottom: MAppSizes.lg,
                left: MAppSizes.lg,
                child: SizedBox(
                  width: 150,
                  child: ElevatedButton(
                    onPressed: onPressed,
                    child: const Text(MAppTexts.scanQRButtonText),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
