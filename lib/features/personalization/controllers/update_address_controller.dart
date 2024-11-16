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
class UpdateAddressController extends GetxController {
  static UpdateAddressController get instance => Get.find();

  final addressCity = TextEditingController();
  final addressProvState = TextEditingController();
  final addressCountry = TextEditingController();
  final userController = UserController.instance;
  final userRepository = UserRepository.instance;
  GlobalKey<FormState> updateAddressFormKey = GlobalKey<FormState>();

  // Initialize user data when Home Screen appears
  @override
  void onInit() {
    initializeAddress();
    super.onInit();
  }

  /// Fetch User Record
  Future<void> initializeAddress() async {
    addressCity.text = userController.user.value.addressCity;
    addressProvState.text = userController.user.value.addressProvState;
    addressCountry.text = userController.user.value.addressCountry;
  }

  Future<void> updateAddress() async {
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
      if (!updateAddressFormKey.currentState!.validate()) {
        // Remove Loader
        FullScreenLoader.stopLoading();
        return;
      }

      // Update user's first and last name in the Firebase Firestore
      Map<String, dynamic> address = {
        'AddressCity': addressCity.text.trim(),
        'AddressProvState': addressProvState.text.trim(),
        'AddressCountry': addressCountry.text.trim()
      };
      await userRepository.updateSingleField(address);

      // Update the Rx User value
      userController.user.value.addressCity = addressCity.text.trim();
      userController.user.value.addressProvState = addressProvState.text.trim();
      userController.user.value.addressCountry = addressCountry.text.trim();

      // Remove Loader
      FullScreenLoader.stopLoading();

      // Redirect to previous page
      Get.off(() => const ProfileScreen());

      // Show Success Message
      MAppLoaders.successSnackBar(
        title: 'Updated Successfully',
        message: 'Your Address has been updated.',
      );
    } catch (e) {
      // Remove Loader
      FullScreenLoader.stopLoading();

      // Show some generic error to the user
      MAppLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }
}
