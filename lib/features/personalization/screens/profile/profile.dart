import 'package:around_museo_de_baler_mobile_app/common/widgets/appbar/appbar.dart';
import 'package:around_museo_de_baler_mobile_app/common/widgets/loaders/shimmer_effect.dart';
import 'package:around_museo_de_baler_mobile_app/common/widgets/texts/section_heading.dart';
import 'package:around_museo_de_baler_mobile_app/features/personalization/screens/forms/change_birthyear.dart';
import 'package:around_museo_de_baler_mobile_app/features/personalization/screens/profile/widgets/profile_menu.dart';
import 'package:around_museo_de_baler_mobile_app/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/images/rounded_image.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../controllers/user_controller.dart';
import '../forms/change_address.dart';
import '../forms/change_gender.dart';
import '../forms/change_name.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;
    final dark = MAppHelperFunctions.isDarkMode(context);

    return Scaffold(
        appBar: MAppBar(
          title: Text(
            'Profile',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          showBackArrow: true,
        ),

        /// Body
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(MAppSizes.defaultSpace),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      /// Profile Picture
                      Obx(() {
                        final networkImage =
                            controller.user.value.profilePicture;
                        final image = networkImage.isNotEmpty
                            ? networkImage
                            : MAppImages.userDefaultProfilePhoto;
                        return controller.imageUploading.value
                            ? const ShimmerEffect(width: 80, height: 80, radius: 100)
                            : RoundedImage(
                                isNetworkImage: networkImage.isNotEmpty,
                                imageUrl: image,
                                width: 80,
                                height: 80,
                                applyImageRadius: true,
                                borderRadius: 100,
                              );
                      }),
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor:
                              dark ? MAppColors.light : MAppColors.dark,
                        ),
                        onPressed: () => controller.uploadUserProfilePicture(context),
                        child: const Text('Change Profile Picture'),
                      ),
                    ],
                  ),
                ),

                /// Details
                const SizedBox(height: MAppSizes.spaceBtwItems / 2),
                const Divider(),
                const SizedBox(height: MAppSizes.spaceBtwItems),

                /// Heading Profile Info
                const SectionHeading(
                    title: 'Profile Information', showActionButton: false),
                const SizedBox(height: MAppSizes.spaceBtwItems),

                ProfileMenu(
                  title: 'Name',
                  value: controller.user.value.fullName,
                  onTap: () => Get.to(() => const ChangeName()),
                ),
                ProfileMenu(
                  title: 'E-mail',
                  value: controller.user.value.email,
                  onTap: () => controller.resetEmailAddress(),
                ),
                ProfileMenu(
                  title: 'Password',
                  value: '••••••••',
                  onTap: () => controller.resetPasswordConfirmationPopup(),
                ),

                const SizedBox(height: MAppSizes.spaceBtwItems / 2),
                const Divider(),
                const SizedBox(height: MAppSizes.spaceBtwItems),

                /// Personal Info
                const SectionHeading(
                    title: 'Personal Information', showActionButton: false),
                const SizedBox(height: MAppSizes.spaceBtwItems),

                ProfileMenu(
                  title: 'Gender',
                  value: controller.user.value.gender.isNotEmpty
                      ? controller.user.value.gender
                      : '_',
                  onTap: () => Get.to(() => const ChangeGender()),
                ),
                ProfileMenu(
                  title: 'Year of Birth',
                  value: controller.user.value.birthYear.isNotEmpty
                      ? controller.user.value.birthYear
                      : '_',
                  onTap: () => Get.to(() => const ChangeBirthYear()),
                ),
                ProfileMenu(
                  title: 'Address',
                  value: controller.user.value.completeAddress,
                  onTap: () => Get.to(() => const ChangeAddress()),
                ),
                const SizedBox(height: MAppSizes.spaceBtwSections),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => controller.deleteAccountWarningPopup(),
                    style: ButtonStyle(
                      side: WidgetStateProperty.resolveWith<BorderSide>(
                        (states) {
                          if (states.contains(WidgetState.disabled)) {
                            // Define disabled state border color if needed
                            return const BorderSide(
                                color: Colors
                                    .grey); // Example color for disabled state
                          }
                          // Define enabled state border color
                          return const BorderSide(
                              color: Colors
                                  .red); // Red border color for enabled state
                        },
                      ),
                    ),
                    child: Text('Delete Account',
                        style: TextStyle(color: Colors.red[800])),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
