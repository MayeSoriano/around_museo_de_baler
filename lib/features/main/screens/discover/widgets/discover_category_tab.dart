import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:around_museo_de_baler_mobile_app/features/main/controllers/location_controller.dart';
import 'package:around_museo_de_baler_mobile_app/common/widgets/locations/location_cards/location_card.dart';
import 'package:around_museo_de_baler_mobile_app/utils/constants/sizes.dart';
import '../../../../../common/widgets/loaders/shimmer_effect.dart';
import '../../../models/location_model.dart';

class DiscoverCategoryTab extends StatelessWidget {
  const DiscoverCategoryTab({
    super.key,
    required this.categoryId,
    required this.locations,
  });

  final String categoryId;
  final RxList<LocationModel> locations;

  @override
  Widget build(BuildContext context) {
    final locationController = LocationController.instance;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: MAppSizes.defaultSpace),
      child: Obx(() {
        if (locationController.isLoading.value || locations.isEmpty) {
          return ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: 4, // Show placeholder shimmer for a fixed number of items
            itemBuilder: (_, index) {
              return const Padding(
                padding: EdgeInsets.only(top: MAppSizes.md),
                child: ShimmerEffect(width: 300, height: 230),
              );
            },
          );
        } else {
          return ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: locations.length,
            itemBuilder: (_, index) {
              return Padding(
                padding: const EdgeInsets.only(top: MAppSizes.md),
                child: LocationCard(
                  height: 170,
                  width: double.infinity,
                  location: locations[index],
                ),
              );
            },
          );
        }
      }),
    );
  }
}
