import 'package:around_museo_de_baler_mobile_app/common/styles/spacing_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../utils/constants/sizes.dart';
import '../../../utils/constants/text_strings.dart';
import '../../../utils/helpers/helper_functions.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({
      super.key,
      required this.image,
      required this.title,
      required this.subtitle,
      required this.onPressed});

  final String image, title, subtitle;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: MAppSpacingStyle.paddingWithAppBarHeight * 2,
          child: Column(
            children: [
              /// Image
              SizedBox(
                width: MAppHelperFunctions.screenWidth() * 0.5,
                child: Lottie.asset(image),
              ),
              const SizedBox(height: MAppSizes.spaceBtwSections),

              /// Title and Subtitle
              Text(
                title,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: MAppSizes.spaceBtwItems),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.labelMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: MAppSizes.spaceBtwSections),

              /// Buttons
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onPressed,
                  child: Text(
                    MAppTexts.continueText.capitalize!,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
