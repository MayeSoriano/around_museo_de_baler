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
class UpdateGenderController extends GetxController {
  static UpdateGenderController get instance => Get.find();

  final gender = TextEditingController();
  final userController = UserController.instance;
  final userRepository = UserRepository.instance;
  GlobalKey<FormState> updateGenderFormKey = GlobalKey<FormState>();

  // Initialize user data when Home Screen appears
  @override
  void onInit() {
    initializeGender();
    super.onInit();
  }

  /// Fetch User Record
  Future<void> initializeGender() async {
    gender.text = userController.user.value.gender;
  }

  Future<void> updateGender() async {
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
      if (!updateGenderFormKey.currentState!.validate()) {
        // Remove Loader
        FullScreenLoader.stopLoading();
        return;
      }

      // Update user's first and last name in the Firebase Firestore
      Map<String, dynamic> updatedGender = {
        'Gender': gender.text.trim(),
      };
      await userRepository.updateSingleField(updatedGender);

      // Update the Rx User value
      userController.user.value.gender = gender.text.trim();

      // Remove Loader
      FullScreenLoader.stopLoading();

      // Show Success Message
      MAppLoaders.successSnackBar(
        title: 'Updated Successfully',
        message: 'Your Gender has been updated.',
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
