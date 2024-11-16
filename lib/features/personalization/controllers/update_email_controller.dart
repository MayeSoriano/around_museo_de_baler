import 'package:around_museo_de_baler_mobile_app/data/repositories/user/user_repository.dart';
import 'package:around_museo_de_baler_mobile_app/features/personalization/controllers/user_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../data/repositories/authentication/authentication_repository.dart';
import '../../../utils/constants/image_strings.dart';
import '../../../utils/network/network_manager.dart';
import '../../../utils/popups/full_screen_loader.dart';
import '../../../utils/popups/loaders.dart';

/// Controller to manage user-related functionality
class UpdateEmailController extends GetxController {
  static UpdateEmailController get instance => Get.find();

  final email = TextEditingController();
  final userController = UserController.instance;
  final userRepository = UserRepository.instance;
  GlobalKey<FormState> updateEmailFormKey = GlobalKey<FormState>();

  Future<void> updateEmailAddress() async {
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
      if (!updateEmailFormKey.currentState!.validate()) {
        // Remove Loader
        FullScreenLoader.stopLoading();
        return;
      }

      final currentUser = FirebaseAuth.instance.currentUser;

      if(email.text.trim() != currentUser?.email) {
        FullScreenLoader.stopLoading();

        // Email Verification required
        final currentUser = FirebaseAuth.instance.currentUser;
        await currentUser?.verifyBeforeUpdateEmail(email.text.trim());

        // Notify User
        MAppLoaders.successSnackBar(
            title: 'Verification Email Sent',
            message: 'Please check your inbox and verify your new email. Once verified, you will need to log in again to continue using the app.'
        );

        // Requires logging-in again
        AuthenticationRepository.instance.logout();
      } else {
        FullScreenLoader.stopLoading();
        MAppLoaders.warningSnackBar(
          title: 'Invalid Email Change',
          message: 'The email address you entered is the same as your current one. Please provide a different email address.',
        );
      }
    } catch (e) {
      // Remove Loader
      FullScreenLoader.stopLoading();

      // Show some generic error to the user
      MAppLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }


}
