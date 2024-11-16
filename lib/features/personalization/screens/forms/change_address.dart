import 'package:around_museo_de_baler_mobile_app/common/widgets/appbar/appbar.dart';
import 'package:around_museo_de_baler_mobile_app/utils/constants/sizes.dart';
import 'package:around_museo_de_baler_mobile_app/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../utils/constants/text_strings.dart';
import '../../controllers/update_address_controller.dart';

class ChangeAddress extends StatelessWidget {
  const ChangeAddress({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UpdateAddressController());

    return Scaffold(
      appBar: MAppBar(
        showBackArrow: true,
        title: Text('Change Address',
            style: Theme.of(context).textTheme.headlineSmall),
      ),
      body: Padding(
        padding: const EdgeInsets.all(MAppSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Headings
            Text(
              'Enter your address for accurate data analysis.',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(height: MAppSizes.spaceBtwSections),

            /// Text Fields and Button
            Form(
              key: controller.updateAddressFormKey,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: controller.addressCity,
                          validator: (value) =>
                              MAppValidator.validateEmptyText('City', value),
                          expands: false,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Iconsax.location),
                            labelText: MAppTexts.addressCity,
                          ),
                        ),
                      ),
                      const SizedBox(width: MAppSizes.spaceBtwInputFields),
                      Expanded(
                        child: TextFormField(
                          controller: controller.addressProvState,
                          validator: (value) => MAppValidator.validateEmptyText(
                              'Province/State', value),
                          expands: false,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Iconsax.location),
                            labelText: MAppTexts.addressProvState,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: MAppSizes.spaceBtwInputFields),
                  TextFormField(
                    controller: controller.addressCountry,
                    validator: (value) =>
                        MAppValidator.validateEmptyText('Country', value),
                    expands: false,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Iconsax.location),
                      labelText: MAppTexts.addressCountry,
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
                onPressed: () => controller.updateAddress(),
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
