import 'package:around_museo_de_baler_mobile_app/common/widgets/loaders/shimmer_effect.dart';
import 'package:around_museo_de_baler_mobile_app/features/personalization/controllers/user_controller.dart';
import 'package:around_museo_de_baler_mobile_app/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../common/widgets/images/rounded_image.dart';
import '../../../../../navigation_menu.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/image_strings.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserController());
    final navController = NavigationController.instance;
    final dark = MAppHelperFunctions.isDarkMode(context);

    return MAppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            MAppTexts.homeAppBarTitle,
            style: Theme.of(context)
                .textTheme
                .labelMedium!
                .apply(color: dark ? MAppColors.grey : MAppColors.darkerGrey),
          ),
          Obx(() {
            if (controller.profileLoading.value) {
              // Display a shimmer loader while user profile is being loaded
              return const ShimmerEffect(width: 200, height: 30);
            }
            return Text(
              controller.user.value.fullName,
              style: Theme.of(context).textTheme.headlineMedium,
            );
          }),
        ],
      ),
      actions: [
        /// User Icon
        Padding(
          padding: const EdgeInsets.only(right: MAppSizes.sm),
          child: GestureDetector(
            onTap: () => navController.selectedIndex.value = 3,
            child: Obx(() {
              final networkImage = controller.user.value.profilePicture;
              final image = networkImage.isNotEmpty
                  ? networkImage
                  : MAppImages.userDefaultProfilePhoto;
              return controller.imageUploading.value
                  ? const ShimmerEffect(width: 45, height: 45, radius: 100)
                  : RoundedImage(
                      isNetworkImage: networkImage.isNotEmpty,
                      imageUrl: image,
                      width: 45,
                      height: 45,
                      applyImageRadius: true,
                      borderRadius: 100,
                    );
            }),
          ),
        ),
      ],
    );
  }
}
