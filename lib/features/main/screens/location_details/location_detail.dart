import 'package:around_museo_de_baler_mobile_app/features/main/models/location_model.dart';
import 'package:around_museo_de_baler_mobile_app/features/main/screens/location_details/widget/bottom_check_in_map.dart';
import 'package:around_museo_de_baler_mobile_app/features/main/screens/location_details/widget/location_detail_image_slider.dart';
import 'package:around_museo_de_baler_mobile_app/features/main/screens/location_details/widget/location_meta_data.dart';
import 'package:around_museo_de_baler_mobile_app/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LocationDetailScreen extends StatelessWidget {
  const LocationDetailScreen({
    super.key,
    required this.location,
  });

  final LocationModel location;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomCheckInMap(location: location),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(Get.height / 2),
        child: LocationDetailImageSlider(location: location),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// Location Details
            Padding(
              padding: const EdgeInsets.only(
                  right: MAppSizes.defaultSpace,
                  left: MAppSizes.defaultSpace,
                  bottom: MAppSizes.defaultSpace,
                  top: MAppSizes.spaceBtwItems / 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LocationMetaData(location: location),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
