import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/device/device_utility.dart';
import '../../../../../utils/helpers/helper_functions.dart';
import '../../../controllers/onboarding/onboarding_controller.dart';

class OnBoardingDotNavigation extends StatelessWidget {
  const OnBoardingDotNavigation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = OnBoardingController.instance;
    final dark = MAppHelperFunctions.isDarkMode(context);

    return Positioned(
        bottom: MAppDeviceUtils.getBottomNavigationBarHeight() + 25,
        left: MAppSizes.defaultSpace,
        child: SmoothPageIndicator(
          count: 3,
          effect: ExpandingDotsEffect(
            activeDotColor: dark ? MAppColors.light : MAppColors.dark,
            dotHeight: 6,
            dotWidth: 10,
          ),
          controller: controller.pageController,
          onDotClicked: controller.dotNavigationClick,
        ));
  }
}
