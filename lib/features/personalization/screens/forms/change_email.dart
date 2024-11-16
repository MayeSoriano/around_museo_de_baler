import 'package:around_museo_de_baler_mobile_app/common/widgets/appbar/appbar.dart';
import 'package:around_museo_de_baler_mobile_app/utils/constants/sizes.dart';
import 'package:around_museo_de_baler_mobile_app/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../utils/constants/text_strings.dart';
import '../../controllers/update_email_controller.dart';

class ChangeEmail extends StatelessWidget {
  const ChangeEmail({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UpdateEmailController());

    return Scaffold(
      appBar: MAppBar(
        showBackArrow: true,
        title: Text('Change Email',
            style: Theme.of(context).textTheme.headlineSmall),
      ),
      body: Padding(
        padding: const EdgeInsets.all(MAppSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Headings
            Text(
              'Enter a valid email address for your account updates and verification.',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(height: MAppSizes.spaceBtwSections),

            /// Text Fields and Button
            Form(
              key: controller.updateEmailFormKey,
              child:  TextFormField(
                controller: controller.email,
                validator: (value) => MAppValidator.validateEmail(value),
                expands: false,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Iconsax.direct_right),
                  labelText: MAppTexts.email,
                ),
              ),
            ),
            const SizedBox(height: MAppSizes.spaceBtwInputFields),

            /// Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => controller.updateEmailAddress(),
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
