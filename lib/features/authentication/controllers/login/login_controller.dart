import 'package:around_museo_de_baler_mobile_app/data/repositories/authentication/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/network/network_manager.dart';
import '../../../../utils/popups/full_screen_loader.dart';
import '../../../../utils/popups/loaders.dart';
import '../../../personalization/controllers/user_controller.dart';

class LoginController extends GetxController {
  /// Variables
  final localStorage = GetStorage();
  final email = TextEditingController();
  final password = TextEditingController();
  final hidePassword = true.obs;
  final rememberMe = false.obs;
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final userController = Get.put(UserController());
  final auth = Get.put(AuthenticationRepository());

  @override
  void onInit() {
    email.text = localStorage.read('REMEMBER_ME_EMAIL') ?? '';
    password.text = localStorage.read('REMEMBER_ME_PASSWORD') ?? '';

    // Check if both email and password are not null
    if (email.text.isNotEmpty && password.text.isNotEmpty) {
      rememberMe.value = true;
    } else {
      rememberMe.value = false;
    }

    super.onInit();
  }

  /// Email and Password Sign-in
  Future<void> emailAndPasswordSignIn() async {
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

      // Form Validation
      if (!loginFormKey.currentState!.validate()) {
        // Remove Loader
        FullScreenLoader.stopLoading();
        return;
      }

      // Save Data if Remember Me is selected
      if (rememberMe.value) {
        localStorage.write('REMEMBER_ME_EMAIL', email.text.trim());
        localStorage.write('REMEMBER_ME_PASSWORD', password.text.trim());
      } else {
        // Delete from local storage if rememberMe is not selected
        // Check if entries exist before removing them
        if (localStorage.hasData('REMEMBER_ME_EMAIL')) {
          localStorage.remove('REMEMBER_ME_EMAIL');
        }
        if (localStorage.hasData('REMEMBER_ME_PASSWORD')) {
          localStorage.remove('REMEMBER_ME_PASSWORD');
        }
      }

      // Login user using Email and Password Authentication
      await AuthenticationRepository.instance
          .loginWithEmailAndPassword(email.text.trim(), password.text.trim());

      // Remove Loader
      FullScreenLoader.stopLoading();

      // Redirect
      AuthenticationRepository.instance.screenRedirect();
    } catch (e) {
      // Remove Loader
      FullScreenLoader.stopLoading();

      // Show some generic error to the user
      MAppLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  /// Google Sign-in Authentication
  Future<void> googleSignIn() async {
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

      // Google Authentication
      final userCredential = await auth.signInWithGoogle();

      // Check if the Google account email is registered
      final email = userCredential?.user!.email;
      final isEmailRegistered = await auth.isRegisteredEmail(email);

      if (isEmailRegistered) {
        // Email is registered, proceed with login
        await auth.signInWithGoogle();

        // Remove Loader
        FullScreenLoader.stopLoading();

        // Redirect
        AuthenticationRepository.instance.screenRedirect();
      } else {
        await AuthenticationRepository.instance
            .deleteUser(userCredential?.user?.uid);

        // Email is not registered, show an error
        FullScreenLoader.stopLoading();
        MAppLoaders.errorSnackBar(
          title: 'Unregistered Email',
          message:
              'This Google account is not registered. Please sign up first.',
        );
      }
    } catch (e) {
      // Remove Loader
      FullScreenLoader.stopLoading();

      MAppLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }
}
