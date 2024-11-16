import 'package:around_museo_de_baler_mobile_app/data/repositories/authentication/authentication_repository.dart';
import 'package:around_museo_de_baler_mobile_app/data/repositories/user/user_repository.dart';
import 'package:around_museo_de_baler_mobile_app/utils/popups/full_screen_loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/network/network_manager.dart';
import '../../../../utils/popups/loaders.dart';
import '../../../personalization/models/user_model.dart';
import '../../screens/signup/verify_email.dart';

class SignupController extends GetxController {
  static SignupController get instance => Get.find();

  /// Variables
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final email = TextEditingController();
  final gender = TextEditingController();
  final birthYear = TextEditingController();
  final addressCity = TextEditingController();
  final addressProvState = TextEditingController();
  final addressCountry = TextEditingController();
  final password = TextEditingController();
  final hidePassword = true.obs;
  final privacyPolicy = false.obs;
  GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();

  void signup() async {
    try {
      // Start Loading
      FullScreenLoader.openLoadingDialog(
          'We are now processing your information...',
          MAppImages.docerAnimation);

      // Check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        // Remove Loader
        FullScreenLoader.stopLoading();
        return;
      }

      // Form Validation
      if (!signupFormKey.currentState!.validate()) {
        // Remove Loader
        FullScreenLoader.stopLoading();
        return;
      }

      // Privacy Policy Check
      if (!privacyPolicy.value) {
        MAppLoaders.warningSnackBar(
          title: 'Accept Privacy Policy',
          message:
              'In order to create account, you must have to read and accept the Privacy Policy & Terms of Use.',
        );
        FullScreenLoader.stopLoading();
        return;
      }

      // Register User in the Firebase Authentication and save user data in the Firebase
      final userCredential = await AuthenticationRepository.instance
          .registerWithEmailAndPassword(
              email.text.trim(), password.text.trim());

      // Save authenticated use data in the Firebase Firestore
      final newUser = UserModel(
        id: userCredential.user!.uid,
        firstName: firstName.text.trim(),
        lastName: lastName.text.trim(),
        email: email.text.trim(),
        gender: gender.text.trim(),
        birthYear: birthYear.text.trim(),
        addressCity: addressCity.text.trim(),
        addressProvState: addressProvState.text.trim(),
        addressCountry: addressCountry.text.trim(),
        profilePicture: '',
      );

      final userRepository = Get.put(UserRepository());
      await userRepository.saveUserRecord(newUser);

      // Remove Loader
      FullScreenLoader.stopLoading();

      // Show Success Message
      MAppLoaders.successSnackBar(
        title: 'Congratulations!',
        message: 'Your account has been created. Verify email to continue.',
      );

      // Move to Verify Email Screen
      Get.to(() => VerifyEmailScreen(email: email.text.trim()));
    } catch (e) {
      // Remove Loader
      FullScreenLoader.stopLoading();

      // Show some generic error to the user
      MAppLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }
}
