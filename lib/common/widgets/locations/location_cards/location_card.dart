import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:around_museo_de_baler_mobile_app/common/widgets/images/rounded_image.dart';
import 'package:around_museo_de_baler_mobile_app/features/main/models/location_model.dart';
import 'package:around_museo_de_baler_mobile_app/features/main/screens/location_details/location_detail.dart';
import 'package:around_museo_de_baler_mobile_app/utils/constants/colors.dart';
import 'package:around_museo_de_baler_mobile_app/utils/constants/image_strings.dart';
import 'package:around_museo_de_baler_mobile_app/utils/constants/sizes.dart';
import 'package:around_museo_de_baler_mobile_app/utils/helpers/helper_functions.dart';
import '../../custom_shapes/containers/rounded_container.dart';
import '../../loaders/shimmer_effect.dart';
import '../favorites/location_favorites_icon_button.dart';
import '../location_texts/location_close_tag.dart';
import '../location_texts/location_details.dart';

class LocationCard extends StatelessWidget {
  const LocationCard({
    super.key,
    this.height = 200,
    this.width = 280,
    required this.location,
  });

  final double height, width;
  final LocationModel location;

  @override
  Widget build(BuildContext context) {
    final dark = MAppHelperFunctions.isDarkMode(context);

    return GestureDetector(
      onTap: () => Get.to(() => LocationDetailScreen(location: location)),
      child: Container(
        width: width,
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(MAppSizes.imageRadius),
          color: dark ? MAppColors.darkerGrey : MAppColors.white,
          border: Border.all(
            color: dark ? Colors.transparent : MAppColors.grey.withOpacity(0.4),
          ),
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

                  Visibility(
                    visible: location.operatingHours!.isNotEmpty &&
                        !location.isOpen &&
                        !location.operatingHours!.containsKey('Status'),
                    child: CloseTag(
                      opensAt: 'Opens at ${location.openTimes}',
                    ),
                  ),

                  LocationFavoriteIconButton(
                    location: location,
                  ),
                ],
              ),
            ),
            const SizedBox(height: MAppSizes.spaceBtwItems / 2),
            LocationDetails(
              title: location.name,
              address: location.address,
            ),
          ],
        ),
      ),
    );
  }
}
