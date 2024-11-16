import 'package:around_museo_de_baler_mobile_app/features/authentication/screens/signup/widgets/terms_conditions_checkbox.dart';
import 'package:around_museo_de_baler_mobile_app/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../../../utils/validators/validation.dart';
import '../../../controllers/signup/signup_controller.dart';

class SignupForm extends StatelessWidget {
  const SignupForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignupController());
    final dark = MAppHelperFunctions.isDarkMode(context);

    return Form(
      key: controller.signupFormKey,
      child: Column(
        children: [
          /// First Name and Last Name
          Row(
            children: [
              /// First Name
              Expanded(
                child: TextFormField(
                  controller: controller.firstName,
                  validator: (value) =>
                      MAppValidator.validateEmptyText('First Name', value),
                  expands: false,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Iconsax.user),
                    labelText: MAppTexts.firstName,
                  ),
                ),
              ),
              const SizedBox(width: MAppSizes.spaceBtwInputFields),

              /// Last Name
              Expanded(
                child: TextFormField(
                  controller: controller.lastName,
                  validator: (value) =>
                      MAppValidator.validateEmptyText('Last Name', value),
                  expands: false,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Iconsax.user),
                    labelText: MAppTexts.lastName,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: MAppSizes.spaceBtwInputFields),

          /// Email
          TextFormField(
            controller: controller.email,
            validator: (value) => MAppValidator.validateEmail(value),
            expands: false,
            decoration: const InputDecoration(
              prefixIcon: Icon(Iconsax.direct_right),
              labelText: MAppTexts.email,
            ),
          ),
          const SizedBox(height: MAppSizes.spaceBtwInputFields),

          /// Gender and Birth Year
          Row(
            children: [
              /// Gender
              Expanded(
                child: DropdownButtonFormField(
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
              ),
              const SizedBox(width: MAppSizes.spaceBtwInputFields),

              /// Birth Year
              Expanded(
                child: TextFormField(
                  controller: controller.birthYear,
                  validator: (value) => MAppValidator.validateBirthYear(value),
                  keyboardType: TextInputType.number,
                  expands: false,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Iconsax.calendar),
                    labelText: MAppTexts.birthYear,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: MAppSizes.spaceBtwInputFields),

          /// Address
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Address',
                    style: Theme.of(context).textTheme.labelLarge,
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: MAppSizes.spaceBtwInputFields),
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
                  validator: (value) =>
                      MAppValidator.validateEmptyText('Province/State', value),
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
          const SizedBox(height: MAppSizes.spaceBtwInputFields),

          /// Password
          Obx(
            () => TextFormField(
              controller: controller.password,
              validator: (value) => MAppValidator.validatePassword(value),
              expands: false,
              obscureText: controller.hidePassword.value,
              decoration: InputDecoration(
                prefixIcon: const Icon(Iconsax.password_check),
                labelText: MAppTexts.password,
                suffixIcon: IconButton(
                  onPressed: () => controller.hidePassword.value =
                      !controller.hidePassword.value,
                  icon: Icon(controller.hidePassword.value
                      ? Iconsax.eye_slash
                      : Iconsax.eye),
                ),
              ),
            ),
          ),
          const SizedBox(height: MAppSizes.spaceBtwSections),

          const TermsAndConditionsCheckbox(),
          const SizedBox(height: MAppSizes.spaceBtwSections),

          /// Sign Up Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => controller.signup(),
              child: const Text(MAppTexts.createAccount),
            ),
          ),
          const SizedBox(height: MAppSizes.spaceBtwItems),
        ],
      ),
    );
  }
}
