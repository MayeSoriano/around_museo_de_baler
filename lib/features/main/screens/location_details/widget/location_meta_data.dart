import 'package:around_museo_de_baler_mobile_app/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:around_museo_de_baler_mobile_app/utils/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:readmore/readmore.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../common/widgets/texts/section_heading.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../controllers/location_controller.dart';
import '../../../models/location_model.dart';
import 'location_about_info.dart';

class LocationMetaData extends StatelessWidget {
  const LocationMetaData({
    super.key,
    required this.location,
  });

  final LocationModel location;

  @override
  Widget build(BuildContext context) {
    final LocationController locationController = Get.find();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Tags - Category, Subcategory
        Row(
          children: [
            RoundedContainer(
              radius: MAppSizes.md,
              backgroundColor: MAppColors.secondary.withOpacity(0.8),
              padding: const EdgeInsets.symmetric(
                  horizontal: MAppSizes.sm, vertical: MAppSizes.xs),
              child: Text(location.categoryName,
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .apply(color: MAppColors.black)),
            ),
            const SizedBox(width: MAppSizes.spaceBtwItems / 2),
            if (location.subCategoryName.isNotEmpty)
              RoundedContainer(
                radius: MAppSizes.md,
                backgroundColor: MAppColors.accent.withOpacity(0.8),
                padding: const EdgeInsets.symmetric(
                    horizontal: MAppSizes.sm, vertical: MAppSizes.xs),
                child: Text(location.subCategoryName,
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium!
                        .apply(color: MAppColors.black)),
              ),
          ],
        ),
        const SizedBox(height: MAppSizes.spaceBtwItems / 2),

        /// Title - Location Name
        Text(
          location.name,
          style: Theme.of(context).textTheme.headlineMedium,
          textAlign: TextAlign.left,
        ),

        /// Address
        const SizedBox(height: MAppSizes.spaceBtwItems / 2),
        Row(
          children: [
            const Icon(Icons.location_pin,
                color: MAppColors.secondary, size: MAppSizes.iconXs),
            const SizedBox(width: MAppSizes.xs),
            Expanded( // Wrap the Text widget with Expanded
              child: Text(
                location.address,
                style: Theme.of(context).textTheme.labelMedium,
                overflow: TextOverflow.visible, // Set overflow property to visible
              ),
            ),
          ],
        ),
        const SizedBox(height: MAppSizes.spaceBtwSections),

        /// Location Overview
        Text(
          'Overview',
          style: Theme.of(context).textTheme.headlineSmall,
          textAlign: TextAlign.left,
        ),
        const SizedBox(height: MAppSizes.spaceBtwItems),
        ReadMoreText(
          location.description.isNotEmpty ? location.description.replaceAll('\\n', '\n') : 'No Information Available',
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.justify,
          trimLines: 4,
          trimMode: TrimMode.Line,
          trimCollapsedText: ' Show more',
          trimExpandedText: ' Show Less',
          moreStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
          lessStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: MAppSizes.spaceBtwItems),

        if (location.contactNumber.isNotEmpty ||
            location.socials.isNotEmpty ||
            location.operatingHours!.isNotEmpty)
          Column(
            children: [
              const Divider(),
              const SizedBox(height: MAppSizes.spaceBtwItems),

              /// About
              const SectionHeading(title: 'About', showActionButton: false),
              const SizedBox(height: MAppSizes.spaceBtwItems),

              if (location.contactNumber.isNotEmpty)
                LocationAboutInfo(
                  leftIcon: Iconsax.call,
                  value: location.contactNumber,
                  rightIcon: Iconsax.copy,
                  onTap: () {
                    if (location.contactNumber.isNotEmpty) {
                      Clipboard.setData(ClipboardData(text: location.contactNumber)).then((_) {
                        MAppLoaders.customToast(message: "Contact number copied to clipboard!");
                      });
                    } else {
                      // Optionally handle the case when the contact number is empty
                      MAppLoaders.customToast(message: "No contact number available.");
                    }
                  },
                ),

              if (location.socials.isNotEmpty)
                LocationAboutInfo(
                  leftIcon: Iconsax.global_search,
                  value: location.socials,
                  rightIcon: Icons.link,
                  onTap: () async {
                    // Launch the URL
                    final Uri url = Uri.parse(location.socials);
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    } else {
                      // Optionally handle the case when the contact number is empty
                      MAppLoaders.customToast(message: "Could not launch URL.");
                    }
                  },
                ),

              if (location.operatingHours!.isNotEmpty)
                Column(
                  children: [
                    Obx(() {
                      return GestureDetector(
                        onTap: () {
                          locationController
                              .toggleOperatingHours(); // Call the method to toggle operating hours
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: MAppSizes.spaceBtwItems / 1.5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (location.operatingHours!
                                  .containsKey('Status'))
                                Row(
                                  children: [
                                    const Expanded(
                                      flex: 1,
                                      child: Icon(Iconsax.clock, size: 18),
                                    ),
                                    const SizedBox(
                                        width: MAppSizes.spaceBtwItems / 2),
                                    Expanded(
                                      flex: 5,
                                      child: Text(
                                        location.operatingHours!['Status'] ??
                                            '',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                                color: location.operatingHours!['Status'] ==
                                                        "Always Open" || location.operatingHours!['Status'] ==
                                                    "Made To Order"
                                                    ? Colors
                                                        .green // Customize color for open status
                                                    : Colors.red,
                                                // Customize color for closed status
                                                fontWeight: FontWeight.w800),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              if (location.operatingHours!.containsKey('Mon'))
                                Row(
                                  children: [
                                    const Expanded(
                                      flex: 1,
                                      child: Icon(Iconsax.clock, size: 18),
                                    ),
                                    const SizedBox(
                                        width: MAppSizes.spaceBtwItems / 2),
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        // then check here
                                        location.isOpen ? 'Open' : 'Closed',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                                color: location.isOpen
                                                    ? Colors.green
                                                    : Colors.red,
                                                fontWeight: FontWeight.w800),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        location.isOpen
                                            ? '(Closes at ${location.closeTimes})'
                                            : '(Opens at ${location.openTimes})',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Expanded(
                                        child: !locationController
                                                .showOperatingHours.value
                                            ? const Icon(Iconsax.arrow_down_1,
                                                size: 18)
                                            : const Icon(Iconsax.arrow_up_2,
                                                size: 18)),
                                  ],
                                ),
                              if (locationController.showOperatingHours.value &&
                                  location.operatingHours!.containsKey('Mon'))
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: MAppSizes.spaceBtwItems / 2),
                                  child: Center(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          locationController
                                              .formatOperatingHours(
                                                  location.operatingHours!),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
            ],
          )
      ],
    );
  }
}
