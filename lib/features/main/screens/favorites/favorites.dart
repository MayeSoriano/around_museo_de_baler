import 'package:around_museo_de_baler_mobile_app/common/widgets/appbar/appbar.dart';
import 'package:around_museo_de_baler_mobile_app/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/locations/location_cards/location_card.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../../controllers/location_controller.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final LocationController locationController =
        Get.find<LocationController>();

    return Scaffold(
      appBar: MAppBar(
        title: Text('Favorites',
            style: Theme.of(context).textTheme.headlineMedium),
        showBackArrow: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          left: MAppSizes.defaultSpace,
          right: MAppSizes.defaultSpace,
          bottom: MAppSizes.defaultSpace,
        ),
        child: Column(
          children: [
            /// Favorite Locations
            Expanded(
              child: Obx(() {
                // Observe changes in favoriteLocations
                final favoriteLocations = locationController.favoriteLocations;

                if (favoriteLocations.isEmpty) {
                  return const Center(
                    child: Text(
                      'No Favorite Location yet.',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.normal),
                    ),
                  );
                }

                return SizedBox(
                  height: MAppHelperFunctions.screenHeight(),
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: favoriteLocations.length,
                    itemBuilder: (_, index) {
                      final location = favoriteLocations[index];
                      return Padding(
                        padding: const EdgeInsets.only(top: MAppSizes.md),
                        child: LocationCard(
                          height: 170,
                          width: double.infinity,
                          location: location, // Use the favorite location
                        ),
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
