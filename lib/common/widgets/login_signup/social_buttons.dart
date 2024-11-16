import 'package:around_museo_de_baler_mobile_app/features/authentication/controllers/login/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/constants/image_strings.dart';
import '../../../utils/constants/sizes.dart';

class SocialButtons extends StatelessWidget {
  const SocialButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());

    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () async {
          controller.googleSignIn();
        },
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              width: MAppSizes.iconMd,
              height: MAppSizes.iconMd,
              image: AssetImage(MAppImages.google),
            ),
            SizedBox(width: 8.0), // Add space between the logo and text
            Text('Sign-in with Google'),
          ],
        ),
      ),
    );
  }
}
