import 'package:around_museo_de_baler_mobile_app/data/repositories/user/user_repository.dart';
import 'package:around_museo_de_baler_mobile_app/features/personalization/controllers/user_controller.dart';
import 'package:around_museo_de_baler_mobile_app/features/personalization/screens/profile/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../utils/constants/image_strings.dart';
import '../../../utils/network/network_manager.dart';
import '../../../utils/popups/full_screen_loader.dart';
import '../../../utils/popups/loaders.dart';

/// Controller to manage user-related functionality
class UpdateBirthYearController extends GetxController {
  static UpdateBirthYearController get instance => Get.find();

  final birthYear = TextEditingController();
  final userController = UserController.instance;
  final userRepository = UserRepository.instance;
  GlobalKey<FormState> updateBirthYearFormKey = GlobalKey<FormState>();

  // Initialize user data when Home Screen appears
  @override
  void onInit() {
    initializeBirthYear();
    super.onInit();
  }

  /// Fetch User Record
  Future<void> initializeBirthYear() async {
    birthYear.text = userController.user.value.birthYear;
  }

  Future<void> updateBirthYear() async {
    try {
      // Start Loading
      FullScreenLoader.openLoadingDialog(
          'We are updating your information...', MAppImages.docerAnimation);

      // Check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        // Remove Loader
        FullScreenLoader.stopLoading();
        return;
      }

      // Form Validation
      if (!updateBirthYearFormKey.currentState!.validate()) {
        // Remove Loader
        FullScreenLoader.stopLoading();
        return;
      }

      // Update user's first and last name in the Firebase Firestore
      Map<String, dynamic> updatedBirthYear = {
        'BirthYear': birthYear.text.trim(),
      };
      await userRepository.updateSingleField(updatedBirthYear);

      // Update the Rx User value
      userController.user.value.birthYear = birthYear.text.trim();

      // Remove Loader
      FullScreenLoader.stopLoading();

      // Show Success Message
      MAppLoaders.successSnackBar(
        title: 'Updated Successfully',
        message: 'Your Year of Birth has been updated.',
      );

      // Redirect to previous page
      Get.off(() => const ProfileScreen());
    } catch (e) {
      // Remove Loader
      FullScreenLoader.stopLoading();

      // Show some generic error to the user
      MAppLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }
}
