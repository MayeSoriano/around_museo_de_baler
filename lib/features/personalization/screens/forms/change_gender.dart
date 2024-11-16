import 'package:around_museo_de_baler_mobile_app/common/widgets/appbar/appbar.dart';
import 'package:around_museo_de_baler_mobile_app/features/personalization/controllers/update_gender_controller.dart';
import 'package:around_museo_de_baler_mobile_app/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/helpers/helper_functions.dart';

class ChangeGender extends StatelessWidget {
  const ChangeGender({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UpdateGenderController());
    final dark = MAppHelperFunctions.isDarkMode(context);

    return Scaffold(
      appBar: MAppBar(
        showBackArrow: true,
        title: Text('Change Gender',
            style: Theme.of(context).textTheme.headlineSmall),
      ),
      body: Padding(
        padding: const EdgeInsets.all(MAppSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Headings
            Text(
              'Select your gender for accurate demographic analysis.',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(height: MAppSizes.spaceBtwSections),

            /// Text Fields and Button
            Form(
              key: controller.updateGenderFormKey,
              child: Column(
                children: [
                  DropdownButtonFormField(
                    isExpanded: true,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Iconsax.man),
                    ),
                    onChanged: (value) {
                      // Update the controller value when an item is selected
                      controller.gender.text = value.toString();
                    },
                    value: controller.gender.text.isNotEmpty
                        ? controller.gender.text
                        : null,
                    hint: Text(
                      'Select Gender',
                      style: Theme.of(context).textTheme.labelMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    items: ['Male', 'Female', 'Non-binary']
                        .map((option) => DropdownMenuItem(
                              value: option,
                              child: Text(
                                option,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .apply(
                                        color: dark
                                            ? MAppColors.white
                                            : MAppColors.black),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: MAppSizes.spaceBtwInputFields),

            /// Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => controller.updateGender(),
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
