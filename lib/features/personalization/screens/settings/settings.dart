import 'package:around_museo_de_baler_mobile_app/common/widgets/appbar/appbar.dart';
import 'package:around_museo_de_baler_mobile_app/common/widgets/custom_shapes/containers/secondary_header_container.dart';
import 'package:around_museo_de_baler_mobile_app/common/widgets/texts/section_heading.dart';
import 'package:around_museo_de_baler_mobile_app/features/personalization/screens/about/about.dart';
import 'package:around_museo_de_baler_mobile_app/features/personalization/screens/terms_and_conditions/terms_and_conditions.dart';
import 'package:around_museo_de_baler_mobile_app/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../common/widgets/list_tiles/settings_menu_tile.dart';
import '../../../../common/widgets/list_tiles/user_profile_tile.dart';
import '../../../../data/repositories/authentication/authentication_repository.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/popups/custom_alert_dialog.dart';
import '../../controllers/user_controller.dart';
import '../profile/profile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// Header
            SecondaryHeaderContainer(
                child: Column(
                  children: [
                    MAppBar(
                      title: Text(
                          'Account',
                          style: Theme.of(context).textTheme.headlineMedium!.apply(color: MAppColors.white),
                      ),
                    ),

                    /// User Profile Card
                    UserProfileTile(onPressed: () => Get.to(() => const ProfileScreen())),
                    const SizedBox(height: MAppSizes.spaceBtwSections),
                  ],
                )
            ),
            /// Body
            Padding(
              padding: const EdgeInsets.all(MAppSizes.defaultSpace),
              child: Column(
                children: [
                  /// Account Settings
                  const SectionHeading(title: 'Settings', showActionButton: false),
                  const SizedBox(height: MAppSizes.spaceBtwItems),

                  SettingsMenuTile(
                    icon: Iconsax.message_question,
                    title: 'Help',
                    subtitle: 'Get assistance and support.',
                    onTap: () => controller.launchEmailSupportRequest(),
                  ),
                  SettingsMenuTile(
                    icon: Iconsax.security_card,
                    title: 'Terms and Conditions',
                    subtitle: 'View Privacy Policy and Terms of Use.',
                    onTap: () => Get.to(() => const TermsAndConditionsScreen()),
                  ),
                  SettingsMenuTile(
                    icon: Iconsax.document,
                    title: 'Feedback',
                    subtitle: 'Share your thoughts with us.',
                    onTap: () => controller.launchGoogleForm(),
                  ),
                  SettingsMenuTile(
                    icon: Iconsax.info_circle,
                    title: 'About',
                    subtitle: 'Learn more about our app.',
                    onTap: () => Get.to(() => const AboutScreen()),
                  ),
                  const SizedBox(height: MAppSizes.spaceBtwSections),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                        onPressed: () {
                          // Show the custom alert dialog
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CustomAlertDialog(
                                title: 'Logout',
                                content: 'Are you sure you want to logout?',
                                onConfirm: () => AuthenticationRepository.instance.logout(),
                              );
                            },
                          );
                        },
                        child: const Text('Logout')),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


