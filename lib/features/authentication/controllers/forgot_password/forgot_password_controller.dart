import 'package:around_museo_de_baler_mobile_app/data/repositories/authentication/authentication_repository.dart';
import 'package:around_museo_de_baler_mobile_app/features/authentication/screens/password_configuration/reset_password.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/network/network_manager.dart';
import '../../../../utils/popups/full_screen_loader.dart';
import '../../../../utils/popups/loaders.dart';

class ForgetPasswordController extends GetxController {
  static ForgetPasswordController get instance => Get.find();

  /// Variables
  final email = TextEditingController();
  GlobalKey<FormState> forgotPasswordFormKey = GlobalKey<FormState>();

  /// Send Reset Password Email
  sendPasswordResetEmail() async {
    try {
      // Start Loading
      FullScreenLoader.openLoadingDialog(
          'Processing your request...', MAppImages.docerAnimation);

      // Check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        // Remove Loader
        FullScreenLoader.stopLoading();
        return;
      }

      // Form Validation
      if (!forgotPasswordFormKey.currentState!.validate()) {
        // Remove Loader
        FullScreenLoader.stopLoading();
        return;
      }

      // Send Email to Reset Password
      await AuthenticationRepository.instance
          .sendPasswordResetEmail(email.text.trim());

      // Remove Loader
      FullScreenLoader.stopLoading();

      // Show Success Screen
      MAppLoaders.successSnackBar(
          title: 'Email Sent',
          message: 'Email link sent to reset your Password.');

      // Redirect
      Get.to(() => ResetPasswordScreen(email: email.text.trim()));
    } catch (e) {
      // Remove Loader
      FullScreenLoader.stopLoading();

      // Show some generic error to the user
      MAppLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  /// Re-send Reset Password Email
  resendPasswordResetEmail(String email) async {
    try {
      // Start Loading
      FullScreenLoader.openLoadingDialog(
          'Logging you in...', MAppImages.docerAnimation);

      // Check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        // Remove Loader
        FullScreenLoader.stopLoading();
        return;
      }

      // Send Email to Reset Password
      await AuthenticationRepository.instance.sendPasswordResetEmail(email);

      // Remove Loader
      FullScreenLoader.stopLoading();

      // Show Success Screen
      MAppLoaders.successSnackBar(
          title: 'Email Sent',
          message: 'Email link sent to reset your Password.');
    } catch (e) {
      // Remove Loader
      FullScreenLoader.stopLoading();

      // Show some generic error to the user
      MAppLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }
}
