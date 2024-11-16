import 'package:flutter/material.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_functions.dart';

class VerticalImageText extends StatelessWidget {
  const VerticalImageText({
    super.key,
    required this.image,
    required this.title,
    this.textColor = MAppColors.white,
    this.backgroundColor,
    this.onTap,
  });

  final String image, title;
  final Color textColor;
  final Color? backgroundColor;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final dark = MAppHelperFunctions.isDarkMode(context);

    return Padding(
      padding: const EdgeInsets.only(right: MAppSizes.spaceBtwItems),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            padding: const EdgeInsets.all(MAppSizes.sm),
            decoration: BoxDecoration(
              color: backgroundColor ??
                  (dark ? MAppColors.black : MAppColors.white),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Center(
              child: Image(
                  image: AssetImage(image),
                  fit: BoxFit.cover,
                  color: dark ? MAppColors.light : MAppColors.dark),
            ),
          ),

          /// Text
          const SizedBox(height: MAppSizes.spaceBtwItems / 2),
          SizedBox(
            width: 75,
            child: Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .labelSmall!
                  .apply(color: textColor),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
