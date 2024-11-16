import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:around_museo_de_baler_mobile_app/common/widgets/images/rounded_image.dart';
import 'package:around_museo_de_baler_mobile_app/features/main/models/location_model.dart';
import 'package:around_museo_de_baler_mobile_app/features/main/screens/location_details/location_detail.dart';
import 'package:around_museo_de_baler_mobile_app/utils/constants/colors.dart';
import 'package:around_museo_de_baler_mobile_app/utils/constants/image_strings.dart';
import 'package:around_museo_de_baler_mobile_app/utils/constants/sizes.dart';
import 'package:around_museo_de_baler_mobile_app/utils/helpers/helper_functions.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../common/widgets/loaders/shimmer_effect.dart';
import '../../../../common/widgets/locations/location_texts/location_details.dart';
import '../../../main/controllers/location_controller.dart';
import '../../controllers/map_controller.dart';
import '../navigation.dart';

class CustomInfoCardWindow extends StatelessWidget {
  const CustomInfoCardWindow({
    super.key,
    this.height = 160,
    this.width = 280,
    required this.location,
  });

  final double height, width;
  final LocationModel location;

  @override
  Widget build(BuildContext context) {
    final CustomInfoWindowController customInfoWindowController =
        CustomInfoWindowController();
    final mapController =
        Get.put<MapController>(MapController(customInfoWindowController));
    final locationController = Get.put(LocationController());

    final dark = MAppHelperFunctions.isDarkMode(context);

    Set<Polyline> polylines = {};
    LatLng origin =
        LatLng(37.42796133580664, -122.085749655962); // Example origin
    LatLng destination =
        LatLng(37.4219999, -122.0840575); // Example destination

    return GestureDetector(
      onTap: () => Get.to(() => LocationDetailScreen(
            location: location,
          )),
      child: Container(
        width: width,
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(MAppSizes.imageRadius),
          color: dark ? MAppColors.darkerGrey : MAppColors.white,
          border: Border.all(
            color: dark ? Colors.transparent : MAppColors.grey.withOpacity(0.4),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1), // Shadow color
              spreadRadius: 1, // Spread radius
              blurRadius: 5, // Blur radius
              offset: const Offset(
                  0, 3), // Changes the position of the shadow
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RoundedContainer(
              height: height,
              backgroundColor: dark ? MAppColors.dark : MAppColors.light,
              child: Stack(
                children: [
                  // Conditionally display image or default image with shimmer effect
                  location.thumbnail.isNotEmpty
                      ? RoundedImage(
                          height: height,
                          width: width,
                          isNetworkImage: true,
                          imageUrl: location.thumbnail,
                          applyImageRadius: true,
                          noBottomRadius: true,
                          fit: BoxFit.cover,
                        )
                      : Stack(
                          children: [
                            // Default image
                            Image.asset(
                              MAppImages.defaultLocationImage,
                              width: width,
                              height: height,
                              fit: BoxFit.cover,
                            ),
                            // Shimmer effect
                            ShimmerEffect(
                              width: width,
                              height: height,
                            ),
                          ],
                        ),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: RoundedContainer(
                      radius: MAppSizes.sm,
                      backgroundColor: MAppColors.darkerGrey.withOpacity(0.8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: MAppSizes.sm, vertical: MAppSizes.xs),
                      child: Text(
                        location.categoryName,
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge!
                            .apply(color: MAppColors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: MAppSizes.spaceBtwItems / 3),
            LocationDetails(
              title: location.name,
              address: location.address,
            ),
            const SizedBox(height: MAppSizes.spaceBtwItems / 3),
            // Add the buttons here
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(
                  onPressed: () {
                    Get.to(() => LocationDetailScreen(
                          location: location,
                        ));
                  },
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(12)),
                  child: const Row(
                    children: [
                      Text('More Info'),
                      SizedBox(width: 5),
                      Icon(Icons.info_outline), // Info icon
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    LatLng destination = LatLng(location.coordinates.latitude,
                        location.coordinates.longitude); // Example destination

                    Get.to(() => NavigationScreen(
                        destination: destination, locationName: location.name));
                  },
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(12)),
                  child: const Row(
                    children: [
                      Text('Directions'),
                      SizedBox(width: 5),
                      Icon(Icons.directions), // Directions icon
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
