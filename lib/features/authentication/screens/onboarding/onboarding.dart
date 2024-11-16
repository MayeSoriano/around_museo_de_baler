import 'package:around_museo_de_baler_mobile_app/features/authentication/controllers/onboarding/onboarding_controller.dart';
import 'package:around_museo_de_baler_mobile_app/features/authentication/screens/onboarding/widgets/onboarding_dot_navigation.dart';
import 'package:around_museo_de_baler_mobile_app/features/authentication/screens/onboarding/widgets/onboarding_next_button.dart';
import 'package:around_museo_de_baler_mobile_app/features/authentication/screens/onboarding/widgets/onboarding_page.dart';
import 'package:around_museo_de_baler_mobile_app/features/authentication/screens/onboarding/widgets/onboarding_skip.dart';
import 'package:around_museo_de_baler_mobile_app/utils/constants/image_strings.dart';
import 'package:around_museo_de_baler_mobile_app/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnBoardingController());

    return Scaffold(
      body: Stack(
        children: [
          /// Horizontal Scrollable Pages
          PageView(
            controller: controller.pageController,
            onPageChanged: controller.updatePageIndicator,
            children: const [
              OnBoardingPage(
                image: MAppImages.onBoardingImg1,
                title: MAppTexts.onBoardingTitle1,
                subtitle: MAppTexts.onBoardingSubtitle1,
              ),
              OnBoardingPage(
                image: MAppImages.onBoardingImg2,
                title: MAppTexts.onBoardingTitle2,
                subtitle: MAppTexts.onBoardingSubtitle2,
              ),
              OnBoardingPage(
                image: MAppImages.onBoardingImg3,
                title: MAppTexts.onBoardingTitle3,
                subtitle: MAppTexts.onBoardingSubtitle3,
              ),
            ],
          ),

          /// Skip Button
          const OnBoardingSkip(),

          /// Dot Navigation SmoothPageIndicator
          const OnBoardingDotNavigation(),

          /// Next Circular Button
          const OnBoardingNextButton(),
        ],
      ),
    );
  }
}
