import 'package:around_museo_de_baler_mobile_app/common/styles/spacing_styles.dart';
import 'package:around_museo_de_baler_mobile_app/features/authentication/screens/login/widgets/login_form.dart';
import 'package:around_museo_de_baler_mobile_app/features/authentication/screens/login/widgets/login_header.dart';
import 'package:around_museo_de_baler_mobile_app/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';

import '../../../../common/widgets/login_signup/form_divider.dart';
import '../../../../common/widgets/login_signup/social_buttons.dart';
import '../../../../utils/constants/sizes.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: MAppSpacingStyle.paddingWithAppBarHeight,
          child: Column(
            children: [
              /// Logo, Title, and Subtitle
              LoginHeader(),

              /// Form
              LoginForm(),

              /// Divider
              FormDivider(dividerText: MAppTexts.orSignInWith),
              SizedBox(height: MAppSizes.spaceBtwSections),

              /// Footer
              SocialButtons(),
            ],
          ),
        ),
      ),
    );
  }
}
