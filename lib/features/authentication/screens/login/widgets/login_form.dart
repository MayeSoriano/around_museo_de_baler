import 'package:around_museo_de_baler_mobile_app/features/authentication/controllers/login/login_controller.dart';
import 'package:around_museo_de_baler_mobile_app/features/authentication/screens/password_configuration/forgot_password.dart';
import 'package:around_museo_de_baler_mobile_app/features/authentication/screens/signup/signup.dart';
import 'package:around_museo_de_baler_mobile_app/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());

    return Form(
      key: controller.loginFormKey,
      child: Padding(
        padding:
            const EdgeInsets.symmetric(vertical: MAppSizes.spaceBtwSections),
        child: Column(
          children: [
            /// Email
            TextFormField(
              controller: controller.email,
              validator: (value) => MAppValidator.validateEmail(value),
              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.direct_right),
                labelText: MAppTexts.email,
              ),
            ),
            const SizedBox(height: MAppSizes.spaceBtwInputFields),

            /// Password
            Obx(
                  () => TextFormField(
                controller: controller.password,
                validator: (value) => MAppValidator.validateEmptyText('Password', value),
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
            const SizedBox(height: MAppSizes.spaceBtwInputFields / 2),

            /// Remember Me and Forgot Password
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// Remember Me
                Row(
                  children: [
                    Obx(() => Checkbox(
                          value: controller.rememberMe.value,
                          onChanged: (value) => controller.rememberMe.value =
                              !controller.rememberMe.value,
                        )),
                    const Text(MAppTexts.rememberMe),
                  ],
                ),

                /// Forgot Password
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: MAppColors.primary,
                  ),
                  onPressed: () => Get.to(() => const ForgotPasswordScreen()),
                  child: const Text(MAppTexts.forgotPassword),
                ),
              ],
            ),
            const SizedBox(height: MAppSizes.spaceBtwSections),

            /// Sign In Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => controller.emailAndPasswordSignIn(),
                child: const Text(MAppTexts.signIn),
              ),
            ),
            const SizedBox(height: MAppSizes.spaceBtwItems),

            /// Create Account Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Get.to(() => const SignupScreen()),
                child: const Text(MAppTexts.createAccount),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
