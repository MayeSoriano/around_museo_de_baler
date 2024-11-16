import 'package:around_museo_de_baler_mobile_app/features/navigation/controllers/map_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../../navigation_menu.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/helpers/helper_functions.dart';
import '../../../models/location_model.dart';

class BottomCheckInMap extends StatelessWidget {
  const BottomCheckInMap({
    super.key,
    required this.location,
  });

  final LocationModel location;

  @override
  Widget build(BuildContext context) {
    // final customInfoWindowController = CustomInfoWindowController();
    // final mapController = Get.put(MapController(customInfoWindowController));
    final navController = NavigationController.instance;
    final dark = MAppHelperFunctions.isDarkMode(context);

    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: MAppSizes.defaultSpace,
          vertical: MAppSizes.defaultSpace / 2),
      decoration: BoxDecoration(
          color: dark ? MAppColors.dark : MAppColors.light.withAlpha(50),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(MAppSizes.cardRadiusLg),
            topRight: Radius.circular(MAppSizes.cardRadiusLg),
          )),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () async {
                Get.back();
                Get.back();
                MapController.selectedLocation = LatLng(
                    location.coordinates.latitude,
                    location.coordinates.longitude);
                navController.selectedIndex.value = 2;
              },
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(MAppSizes.md)),
              child: const Text('Check in Map'),
            ),
          )
        ],
      ),
    );
  }
}
