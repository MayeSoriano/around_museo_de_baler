import 'package:around_museo_de_baler_mobile_app/features/authentication/controllers/signup/signup_controller.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../../../utils/helpers/helper_functions.dart';
import '../../../../personalization/screens/terms_and_conditions/terms_and_conditions.dart';

class TermsAndConditionsCheckbox extends StatelessWidget {
  const TermsAndConditionsCheckbox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = SignupController.instance;
    final dark = MAppHelperFunctions.isDarkMode(context);

    return Row(
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Obx(() => Checkbox(
                value: controller.privacyPolicy.value,
                onChanged: (value) => controller.privacyPolicy.value =
                    !controller.privacyPolicy.value,
              )),
        ),
        const SizedBox(width: MAppSizes.spaceBtwItems),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                  text: '${MAppTexts.iAgreeTo} ',
                  style: Theme.of(context).textTheme.labelLarge),
              TextSpan(
                text: "Privacy Policy and Terms of Use.",
                style: Theme.of(context).textTheme.labelLarge!.apply(
                      color: dark ? MAppColors.white : MAppColors.primary,
                      decoration: TextDecoration.underline,
                      decorationColor:
                          dark ? MAppColors.white : MAppColors.primary,
                    ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Get.to(() => const TermsAndConditionsScreen());
                  },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
