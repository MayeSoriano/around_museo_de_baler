import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../features/main/controllers/location_controller.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/helpers/helper_functions.dart';

class FavoritesCounterIcon extends StatelessWidget {
  const FavoritesCounterIcon({
    super.key,
    required this.onPressed,
    required this.iconColor,
  });

  final VoidCallback onPressed;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    final LocationController locationController = Get.find<LocationController>();
    final dark = MAppHelperFunctions.isDarkMode(context);

    return Stack(
      children: [
        IconButton(
          onPressed: onPressed,
          icon: Icon(Iconsax.heart, color: iconColor),
        ),
        Positioned(
          right: 0,
          child: Obx(() {
            // Wrap this part with Obx to react to changes in favoriteLocations
            return Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: dark
                    ? MAppColors.white.withOpacity(0.5)
                    : MAppColors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Center(
                child: Text(
                  '${locationController.favoriteLocations.length}', // Reactive
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge!
                      .apply(color: MAppColors.white, fontSizeFactor: 0.8),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
