import 'package:flutter/material.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/device/device_utility.dart';
import '../../../../utils/helpers/helper_functions.dart';

class SearchContainer extends StatelessWidget {
  const SearchContainer({
    super.key,
    required this.text,
    this.icon = Icons.search,
    this.showBackground = true,
    this.showBorder = true,
    this.onTap,
    this.padding =
        const EdgeInsets.symmetric(horizontal: MAppSizes.defaultSpace),
  });

  final String text;
  final IconData? icon;
  final bool showBackground, showBorder;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final dark = MAppHelperFunctions.isDarkMode(context);

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: padding,
        child: Container(
          width: MAppDeviceUtils.getScreenWidth(context),
          padding: const EdgeInsets.all(MAppSizes.md),
          decoration: BoxDecoration(
            color: showBackground
                ? dark
                    ? MAppColors.dark
                    : MAppColors.white
                : Colors.transparent,
            borderRadius: BorderRadius.circular(MAppSizes.cardRadiusLg),
            border: showBorder ? Border.all(color: MAppColors.grey) : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(text, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(width: MAppSizes.spaceBtwItems),
              Icon(icon, color: MAppColors.darkGrey),
            ],
          ),
        ),
      ),
    );
  }
}
