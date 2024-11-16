import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../features/main/controllers/location_controller.dart';
import '../../../../features/main/models/location_model.dart';
import '../../../../utils/constants/colors.dart';
import '../../../icons/circular_icon.dart';

class LocationFavoriteIconButton extends StatelessWidget {
  final LocationModel location;
  final double width, height;

  LocationFavoriteIconButton({
    Key? key,
    required this.location,
    this.width = 40,
    this.height = 40,
  }) : super(key: key);

  final LocationController locationController = Get.find<LocationController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Check if the location is a favorite
      bool isFavorite =
          locationController.favoriteLocationIds.contains(location.id);

      return Positioned(
        top: 12,
        right: 12,
        child: GestureDetector(
          onTap: () async {
            // Toggle the favorite status using GetX
            await locationController.toggleFavorite(location.id);
          },
          child: CircularIcon(
            icon: isFavorite ? Iconsax.heart5 : Iconsax.heart,
            color: isFavorite ? Colors.red : MAppColors.darkGrey,
            width: width,
            height: height,
          ),
        ),
      );
    });
  }
}
