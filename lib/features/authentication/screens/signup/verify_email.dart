import 'package:around_museo_de_baler_mobile_app/data/repositories/authentication/authentication_repository.dart';
import 'package:around_museo_de_baler_mobile_app/features/authentication/controllers/signup/verify_email_controller.dart';
import 'package:around_museo_de_baler_mobile_app/utils/constants/image_strings.dart';
import 'package:around_museo_de_baler_mobile_app/utils/helpers/helper_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({
    super.key,
    this.email,
  });

  final String? email;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VerifyEmailController());

    return Scaffold(
      /// The close icon in the app bar is used to logout the user and redirect them to the login screen.
      /// This approach is taken to handle scenarios where the user enters the registration process,
      /// and the data is stored. Upon reopening the app, it checks if the email is verified.
      /// If not verified, the app always navigate to the verification screen.

      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () => AuthenticationRepository.instance.logout(),
            icon: const Icon(CupertinoIcons.clear),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(MAppSizes.defaultSpace),
          child: Column(
            children: [
              /// Image
              SizedBox(
                width: MAppHelperFunctions.screenWidth() * 0.5,
                child: Lottie.asset(MAppImages.emailSentAnimation),
              ),
              const SizedBox(height: MAppSizes.spaceBtwSections),

              /// Title and Subtitle
              Text(
                MAppTexts.verifyEmailTitle,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: MAppSizes.spaceBtwItems),
              Text(
                email ?? '', // user email
                style: Theme.of(context).textTheme.labelLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: MAppSizes.spaceBtwItems),
              Text(
                MAppTexts.verifyEmailSubtitle,
                style: Theme.of(context).textTheme.labelMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: MAppSizes.spaceBtwSections),

              /// Buttons
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => controller.checkEmailVerificationStatus(),
                  child: Text(
                    MAppTexts.continueText.capitalize!,
                  ),
                ),
              ),
              const SizedBox(height: MAppSizes.spaceBtwItems),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: MAppColors.primary,
                  ),
                  onPressed: () => controller.sendEmailVerification(),
                  child: const Text(
                    MAppTexts.resendEmail,
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
