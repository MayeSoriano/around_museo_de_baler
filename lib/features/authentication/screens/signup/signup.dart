import 'package:around_museo_de_baler_mobile_app/features/authentication/screens/signup/widgets/signup_form.dart';
import 'package:around_museo_de_baler_mobile_app/features/authentication/screens/signup/widgets/signup_header.dart';
import 'package:around_museo_de_baler_mobile_app/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

import '../../../../common/widgets/appbar/appbar.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: MAppBar(
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(MAppSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Title and Subtitle
              SignupHeader(),
              SizedBox(height: MAppSizes.spaceBtwSections),

              /// Form
              SignupForm(),
            ],
          ),
        ),
      ),
    );
  }
}
