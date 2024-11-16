import 'package:around_museo_de_baler_mobile_app/features/personalization/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:get/get.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/image_strings.dart';
import '../../../utils/constants/sizes.dart';
import '../images/rounded_image.dart';
import '../loaders/shimmer_effect.dart';

class UserProfileTile extends StatelessWidget {
  const UserProfileTile({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: MAppSizes.md),
      child: ListTile(
        /// Profile Picture
        leading: Obx(() {
          final networkImage = controller.user.value.profilePicture;
          final image = networkImage.isNotEmpty
              ? networkImage
              : MAppImages.userDefaultProfilePhoto;
          return controller.imageUploading.value
              ? const ShimmerEffect(width: 50, height: 50, radius: 100)
              : RoundedImage(
                  isNetworkImage: networkImage.isNotEmpty,
                  imageUrl: image,
                  width: 50,
                  height: 50,
                  applyImageRadius: true,
                  borderRadius: 100,
                );
        }),
        title: Text(
          controller.user.value.fullName,
          style: Theme.of(context)
              .textTheme
              .headlineSmall!
              .apply(color: MAppColors.white),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          controller.user.value.email,
          style: Theme.of(context)
              .textTheme
              .labelMedium!
              .apply(color: MAppColors.white),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: IconButton(
          onPressed: onPressed,
          icon: const Icon(Iconsax.edit, color: MAppColors.white),
        ),
      ),
    );
  }
}
