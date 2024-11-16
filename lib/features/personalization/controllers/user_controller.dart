import 'package:around_museo_de_baler_mobile_app/data/repositories/authentication/authentication_repository.dart';
import 'package:around_museo_de_baler_mobile_app/features/personalization/screens/forms/re_authenticate_user_login_email_change.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../data/repositories/user/user_repository.dart';
import '../../../utils/constants/image_strings.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/network/network_manager.dart';
import '../../../utils/popups/full_screen_loader.dart';
import '../../../utils/popups/loaders.dart';
import '../../authentication/screens/login/login.dart';
import '../models/user_model.dart';
import '../screens/forms/change_email.dart';
import '../screens/forms/re_authenticate_user_login_for_deletion.dart';
import '../screens/profile/profile.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find();

  /// Variables
  final profileLoading = false.obs;
  final imageUploading = false.obs;
  Rx<UserModel> user = UserModel.empty().obs;
  final userRepository = Get.put(UserRepository());
  final hidePassword = true.obs;
  final verifyEmail = TextEditingController();
  final verifyPassword = TextEditingController();
  GlobalKey<FormState> reAuthFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    fetchUserRecord();
  }

  /// Function to fetch user record
  Future<void> fetchUserRecord() async {
    try {
      profileLoading.value = true;
      final user = await userRepository.fetchUserDetails();
      this.user(user);
    } catch (e) {
      user(UserModel.empty());
    } finally {
      profileLoading.value = false;
    }
  }

  /// Delete Account Warning
  void deleteAccountWarningPopup() {
    Get.defaultDialog(
      contentPadding: const EdgeInsets.all(MAppSizes.md),
      title: 'Delete Account',
      middleText:
          'Are you sure you want to delete your account permanently? This action is not reversible and your user account will be removed permanently.',
      confirm: ElevatedButton(
        onPressed: () async => deleteUserAccount(),
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            side: const BorderSide(color: Colors.red)),
        child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: MAppSizes.lg),
            child: Text('Delete')),
      ),
      cancel: OutlinedButton(
        onPressed: () => Navigator.of(Get.overlayContext!).pop(),
        child: const Text('Cancel'),
      ),
    );
  }

  /// Reset Password Popup
  void resetPasswordConfirmationPopup() {
    Get.defaultDialog(
      contentPadding: const EdgeInsets.all(MAppSizes.md),
      title: 'Reset Password',
      middleText:
          'You will receive an email with a link to reset your password. Please check your inbox and follow the instructions to complete the process.',
      confirm: ElevatedButton(
        onPressed: () async {
          resetPassword();
          Navigator.of(Get.overlayContext!).pop();
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            side: const BorderSide(color: Colors.green)),
        child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: MAppSizes.lg),
            child: Text('Confirm')),
      ),
      cancel: OutlinedButton(
        onPressed: () => Navigator.of(Get.overlayContext!).pop(),
        child: const Text('Cancel'),
      ),
    );
  }

  /// Delete User Account
  void deleteUserAccount() async {
    try {
      // Start Loading
      FullScreenLoader.openLoadingDialog(
          'Processing...', MAppImages.docerAnimation);

      // First Re-authenticate user
      final auth = AuthenticationRepository.instance;
      final provider =
          auth.authUser!.providerData.map((e) => e.providerId).first;

      if (provider.isNotEmpty) {
        // Re-verify Auth Email
        if (provider == 'google.com') {
          await auth.signInWithGoogle();
          await auth.deleteAccount();
          FullScreenLoader.stopLoading();
          Get.offAll(() => const LoginScreen());
        } else if (provider == 'password') {
          FullScreenLoader.stopLoading();
          Get.to(() => const ReAuthLoginFormForDeletion());
        }
      }
    } catch (e) {
      // Remove Loader
      FullScreenLoader.stopLoading();
      // Show some generic error to the user
      MAppLoaders.warningSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  /// Re-authenticate before deleting
  Future<void> reAuthenticateEmailAndPasswordForDeletion() async {
    try {
      // Start Loading
      FullScreenLoader.openLoadingDialog(
          'Processing...', MAppImages.docerAnimation);

      // Check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        // Remove Loader
        FullScreenLoader.stopLoading();
        return;
      }

      // Form Validation
      if (!reAuthFormKey.currentState!.validate()) {
        // Remove Loader
        FullScreenLoader.stopLoading();
        return;
      }

      await AuthenticationRepository.instance
          .reAuthenticateWithEmailAndPassword(
              verifyEmail.text.trim(), verifyPassword.text.trim());
      await AuthenticationRepository.instance.deleteAccount();

      // Remove Loader
      FullScreenLoader.stopLoading();

      // Show Success Message
      MAppLoaders.successSnackBar(
        title: 'Account Deleted Successfully',
        message: 'Your account has been deleted.',
      );

      // Redirect
      Get.offAll(() => const LoginScreen());
    } catch (e) {
      // Remove Loader
      FullScreenLoader.stopLoading();

      // Show some generic error to the user
      MAppLoaders.warningSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  /// Reset Email Address
  void resetEmailAddress() async {
    try {
      // Start Loading
      FullScreenLoader.openLoadingDialog(
          'Processing...', MAppImages.docerAnimation);

      // Get current authentication instance and provider
      final auth = AuthenticationRepository.instance;
      final currentUser = auth.authUser;
      final provider =
          auth.authUser!.providerData.map((e) => e.providerId).first;

      if (provider.isNotEmpty) {
        if (provider == 'google.com') {
          // Re-authenticate using Google
          await auth.signInWithGoogle();
          FullScreenLoader.stopLoading();

          // Check if the newly authenticated email matches the current email
          if (auth.authUser?.email != currentUser?.email) {
            MAppLoaders.errorSnackBar(
              title: 'Invalid re-authentication',
              message: 'Cannot change email with a different Google account.',
            );

            // Redirect to Change Email Screen
            Get.off(() => const ProfileScreen());
          } else {
            // Redirect to Change Email Screen
            Get.off(() => const ChangeEmail());
          }
        } else if (provider == 'password') {
          FullScreenLoader.stopLoading();

          // Redirect to re-authentication form for email/password
          Get.to(() => const ReAuthLoginFormEmailChange());
        }
      }
    } catch (e) {
      // Remove Loader
      FullScreenLoader.stopLoading();

      // Show error to user
      MAppLoaders.warningSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  /// Re-authenticate for email/password before email change
  Future<void> reAuthenticateEmailAndPasswordEmailChange() async {
    try {
      // Start Loading
      FullScreenLoader.openLoadingDialog(
          'Processing...', MAppImages.docerAnimation);

      // Check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        FullScreenLoader.stopLoading();
        return;
      }

      // Form Validation (e.g., email and password are filled)
      if (!reAuthFormKey.currentState!.validate()) {
        FullScreenLoader.stopLoading();
        return;
      }

      // Re-authenticate user
      await AuthenticationRepository.instance
          .reAuthenticateWithEmailAndPassword(
        verifyEmail.text.trim(),
        verifyPassword.text.trim(),
      );

      // Stop loading and redirect to change email screen
      FullScreenLoader.stopLoading();
      Get.off(() => const ChangeEmail());
    } catch (e) {
      FullScreenLoader.stopLoading();
      MAppLoaders.warningSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  /// Reset Password
  void resetPassword() async {
    try {
      // Get the current user's email
      final email = AuthenticationRepository.instance.authUser?.email;

      // Check if the email is available
      if (email != null && email.isNotEmpty) {
        // Send password reset email
        await AuthenticationRepository.instance.sendPasswordResetEmail(email);

        // Show success message
        MAppLoaders.successSnackBar(
          title: 'Password Reset Link Sent',
          message:
              'Please check your inbox for the reset link and follow the instructions.',
        );
      }
    } catch (e) {
      // Show some generic error to the user
      MAppLoaders.warningSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  Future<void> uploadUserProfilePicture(BuildContext context) async {
    try {
      final ImageSource? source = await showModalBottomSheet<ImageSource>(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Choose an action',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        IconButton(
                          icon: SizedBox(
                              width: 40,
                              height: 40,
                              child: Image.asset(MAppImages.cameraIcon)),
                          onPressed: () =>
                              Navigator.of(context).pop(ImageSource.camera),
                        ),
                        const Text(
                          'Camera',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                          icon: SizedBox(
                            width: 40,
                            height: 40,
                              child: Image.asset(MAppImages.galleryIcon)),
                          onPressed: () =>
                              Navigator.of(context).pop(ImageSource.gallery),
                        ),
                        const Text(
                          'Gallery',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );

      if (source == null) {
        return; // User canceled the dialog
      }

      final image = await ImagePicker().pickImage(
        source: source,
        imageQuality: 70,
        maxHeight: 512,
        maxWidth: 512,
      );

      if (image != null) {
        imageUploading.value = true;

        // Upload Image
        final imageUrl =
            await userRepository.uploadImage('Users/Images/Profile/', image);

        // Update User Image Record
        Map<String, dynamic> json = {'ProfilePicture': imageUrl};
        await userRepository.updateSingleField(json);

        // Update Rx User Profile Picture
        user.value.profilePicture = imageUrl;
        user.refresh();

        // Show Success Message
        MAppLoaders.successSnackBar(
          title: 'Image Uploaded',
          message: 'Your profile picture has been updated.',
        );
      }
    } catch (e) {
      // Remove Loader
      FullScreenLoader.stopLoading();

      // Show error message
      MAppLoaders.warningSnackBar(title: 'Oh Snap!', message: e.toString());
    } finally {
      imageUploading.value = false;
    }
  }

  /// Redirect to Email
  Future<void> launchEmailSupportRequest() async {
    final String subject = Uri.encodeComponent('App Support Request');
    final String body = Uri.encodeComponent(
        'Hello,\n\nI am experiencing the following issue:\n\n[Describe your issue here]\n\nThank you.');

    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'around.museodebaler.assist@gmail.com',
      query: 'subject=$subject&body=$body',
    );

    try {
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
      } else {
        throw 'Could not launch $emailUri';
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  /// Redirect to Google Forms
  void launchGoogleForm() async {
    const url = 'https://forms.gle/CfkpgJ5rHKRYZFj57';

    final Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (kDebugMode) {
        print('Could not launch $url');
      }
    }
  }
}
