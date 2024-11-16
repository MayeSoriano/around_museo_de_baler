import 'package:around_museo_de_baler_mobile_app/common/widgets/appbar/appbar.dart';
import 'package:around_museo_de_baler_mobile_app/features/personalization/controllers/update_gender_controller.dart';
import 'package:around_museo_de_baler_mobile_app/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../utils/constants/text_strings.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../../../../utils/validators/validation.dart';
import '../../controllers/update_birthyear_controller.dart';

class ChangeBirthYear extends StatelessWidget {
  const ChangeBirthYear({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UpdateBirthYearController());
    final dark = MAppHelperFunctions.isDarkMode(context);

    return Scaffold(
      appBar: MAppBar(
        showBackArrow: true,
        title: Text('Change Year of Birth',
            style: Theme.of(context).textTheme.headlineSmall),
      ),
      body: Padding(
        padding: const EdgeInsets.all(MAppSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Headings
            Text(
              'Enter your birth year to help us analyze visitor demographics effectively.',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(height: MAppSizes.spaceBtwSections),

            /// Text Fields and Button
            Form(
              key: controller.updateBirthYearFormKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: controller.birthYear,
                    validator: (value) => MAppValidator.validateBirthYear(value),
                    keyboardType: TextInputType.number,
                    expands: false,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Iconsax.calendar),
                      labelText: MAppTexts.birthYear,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: MAppSizes.spaceBtwInputFields),

            /// Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => controller.updateBirthYear(),
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
