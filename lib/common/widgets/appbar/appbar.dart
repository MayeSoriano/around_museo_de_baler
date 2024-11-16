import 'package:around_museo_de_baler_mobile_app/utils/device/device_utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_functions.dart';
import '../../icons/circular_icon.dart';

class MAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MAppBar({
    super.key,
    this.title,
    this.showBackArrow = false,
    this.leadingIcon,
    this.actions,
    this.leadingOnPressed,
    this.darkMode = true,
    this.showBackArrowWithBg = false,
  });

  final Widget? title;
  final bool showBackArrow;
  final bool showBackArrowWithBg;
  final IconData? leadingIcon;
  final List<Widget>? actions;
  final VoidCallback? leadingOnPressed;
  final bool darkMode;

  @override
  Widget build(BuildContext context) {
    final dark = MAppHelperFunctions.isDarkMode(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: MAppSizes.md),
      child: AppBar(
        automaticallyImplyLeading: false,
        leading: showBackArrow
            ? showBackArrowWithBg
                ? GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: const CircularIcon(
                        icon: Iconsax.arrow_left,
                        color: MAppColors.dark,
                        size: 20,
                      ),
                    ),
                  )
                : IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(Iconsax.arrow_left,
                        color: darkMode
                            ? dark
                                ? MAppColors.white
                                : MAppColors.black
                            : MAppColors.black))
            : leadingIcon != null
                ? IconButton(
                    onPressed: () => leadingOnPressed,
                    icon: Icon(leadingIcon),
                  )
                : null,
        title: title,
        actions: actions,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(MAppDeviceUtils.getAppBarHeight());
}
