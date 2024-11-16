import 'package:around_museo_de_baler_mobile_app/common/widgets/appbar/appbar.dart';
import 'package:around_museo_de_baler_mobile_app/common/widgets/custom_shapes/curved_edges/curved_edges_widget.dart';
import 'package:around_museo_de_baler_mobile_app/common/widgets/locations/favorites/location_favorites_icon_button_2.dart';
import 'package:around_museo_de_baler_mobile_app/features/main/models/location_model.dart';
import 'package:around_museo_de_baler_mobile_app/utils/constants/colors.dart';
import 'package:around_museo_de_baler_mobile_app/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

import 'location_image_slider.dart';

class LocationDetailImageSlider extends StatelessWidget {
  const LocationDetailImageSlider({
    super.key,
    required this.location,
  });

  final LocationModel location;

  @override
  Widget build(BuildContext context) {
    final dark = MAppHelperFunctions.isDarkMode(context);
    // Convert the list of image URLs to the required format
    final List<Map<String, String>> imageList = (location.images ?? [])
        .map((imageUrl) => {'imageUrl': imageUrl})
        .toList();

    return CurvedEdgesWidget(
      child: Container(
        color: dark ? MAppColors.darkerGrey : MAppColors.light,
        child: Stack(
          children: [
            LocationImageSlider(
              locations: imageList,
            ),

            /// Appbar Icon
            MAppBar(
              showBackArrow: true,
              showBackArrowWithBg: true,
              actions: [
                LocationFavoriteIconButton2(
                  width: 50,
                  height: 50,
                  location: location,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
