import 'package:around_museo_de_baler_mobile_app/features/authentication/controllers/forgot_password/forgot_password_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../login/login.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({
    super.key,
    required this.email,
  });

  final String email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () => Get.offAll(() => const LoginScreen()),
            icon: const Icon(CupertinoIcons.clear),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(MAppSizes.defaultSpace),
        child: Column(
          children: [
            /// Image
            SizedBox(
              width: MAppHelperFunctions.screenWidth() * 0.5,
              child: Lottie.asset(MAppImages.emailSentAnimation),
            ),
            const SizedBox(height: MAppSizes.spaceBtwSections),

            /// User Email, Title, and Subtitle
            Text(
              email,
              style: Theme.of(context).textTheme.labelMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: MAppSizes.spaceBtwItems),
            Text(
              MAppTexts.resetPassTitle,
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: MAppSizes.spaceBtwItems),
            Text(
              MAppTexts.resetPassSubtitle,
              style: Theme.of(context).textTheme.labelMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: MAppSizes.spaceBtwSections),

            /// Buttons
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Get.offAll(() => const LoginScreen()),
                child: Text(
                  MAppTexts.doneText.capitalize!,
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
                onPressed: () => ForgetPasswordController.instance
                    .resendPasswordResetEmail(email),
                child: const Text(
                  MAppTexts.resendEmail,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
