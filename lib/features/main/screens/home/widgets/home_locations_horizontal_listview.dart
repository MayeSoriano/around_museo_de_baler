import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/widgets/locations/location_cards/location_card.dart';
import '../../../../../navigation_menu.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../../../features/main/controllers/location_controller.dart';
import '../../../../../common/widgets/loaders/shimmer_effect.dart';

class LocationsHorizontalListView extends StatelessWidget {
  const LocationsHorizontalListView({super.key});

  @override
  Widget build(BuildContext context) {
    final navController = NavigationController.instance;
    final locationController = Get.put(LocationController());

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: MAppSizes.defaultSpace),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Where to go next?',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.left,
              ),
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: MAppColors.primary,
                ),
                onPressed: () => navController.selectedIndex.value = 1,
                child: const Text(MAppTexts.viewAll),
              ),
            ],
          ),
          const SizedBox(height: MAppSizes.spaceBtwItems),
          SizedBox(
            height: 270,
            child: Obx(() {
              if (locationController.isLoading.value ||
                  locationController.featuredLocations.isEmpty) {
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 4,
                  shrinkWrap: true,
                  // Show placeholder shimmer for a fixed number of items
                  itemBuilder: (_, index) {
                    return const Padding(
                      padding: EdgeInsets.only(right: MAppSizes.md),
                      child: ShimmerEffect(width: 280, height: 200),
                    );
                  },
                );
              } else {
                return ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: locationController.featuredLocations.length,
                  itemBuilder: (_, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: MAppSizes.md),
                      child: LocationCard(
                        location: locationController.featuredLocations[index],
                      ),
                    );
                  },
                );
              }
            }),
          ),
        ],
      ),
    );
  }
}
