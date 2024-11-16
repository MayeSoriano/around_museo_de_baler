import 'package:around_museo_de_baler_mobile_app/data/repositories/user/user_repository.dart';
import 'package:around_museo_de_baler_mobile_app/features/authentication/screens/login/login.dart';
import 'package:around_museo_de_baler_mobile_app/features/authentication/screens/signup/verify_email.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../features/authentication/screens/onboarding/onboarding.dart';
import '../../../navigation_menu.dart';
import '../../../utils/exceptions/firebase_auth_exceptions.dart';
import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';

/// Repository class for authentication operations
class AuthenticationRepository extends GetxService {
  static AuthenticationRepository get instance =>
      Get.put(AuthenticationRepository());

  /// Variables
  final deviceStorage = GetStorage();
  final _auth = FirebaseAuth.instance;

  /// Get Authenticated User Data
  User? get authUser => _auth.currentUser;

  /// Called from main.dart on app launch
  @override
  void onReady() {
    // Stop displaying the Native Splash Screen
    FlutterNativeSplash.remove();
    // Redirect to the appropriate screen
    screenRedirect();
  }

  /// Function to show relevant screen
  screenRedirect() async {
    final user = _auth.currentUser;

    if (user != null) {
      // Update the LastActive field when the user is logged in
      updateLastActive(user.uid);

      if (user.emailVerified) {
        Get.offAll(() => const NavigationMenu());
      } else {
        Get.offAll(() => VerifyEmailScreen(email: _auth.currentUser?.email));
      }
    } else {
      // Local Storage
      deviceStorage.writeIfNull('isFirstTime', true);
      // Check if it's the first time launching the app
      deviceStorage.read('isFirstTime') != true
          ? Get.offAll(() =>
              const LoginScreen()) // Redirect to Login Screen if not the first time
          : Get.offAll(() =>
              const OnBoardingScreen()); // Redirect to OnBoarding Screen if it's the first time
    }
  }

  /// Update the LastActive field when the user is logged in
  void updateLastActive(String uid) async {
    if (uid.isNotEmpty) {
      try {
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(uid)
            .update({'LastActive': Timestamp.now()});
      } catch (e) {
        if (kDebugMode) {
          print('Failed to update last active time: $e');
        }
      }
    }
  }

  /* -------------------- Email and Password Sign-in --------------------*/

  /// [Email Authentication] - Login
  Future<UserCredential> loginWithEmailAndPassword(
      String email, String password) async {
    try {
      // Attempt to log in the user
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      // Check and update the Firestore email if needed
      await updateFirestoreEmailIfNeeded(userCredential.user?.uid, email);

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw MAppFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw MAppFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const MAppFormatException();
    } on PlatformException catch (e) {
      throw MAppPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }

  /// [Email Authentication] - Register
  Future<UserCredential> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw MAppFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw MAppFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const MAppFormatException();
    } on PlatformException catch (e) {
      throw MAppPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }

  /// [Email Verification] - Mail Verification
  Future<void> sendEmailVerification() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw MAppFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw MAppFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const MAppFormatException();
    } on PlatformException catch (e) {
      throw MAppPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }

  /// [Email Authentication] - Forget Password
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw MAppFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw MAppFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const MAppFormatException();
    } on PlatformException catch (e) {
      throw MAppPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }

  /// Match the login email to the firestore email of the user
  Future<void> updateFirestoreEmailIfNeeded(
      String? uid, String authEmail) async {
    if (uid != null) {
      try {
        // Get the Firestore email
        DocumentSnapshot userDoc =
            await FirebaseFirestore.instance.collection('Users').doc(uid).get();

        String? firestoreEmail = userDoc['Email'];

        // If the Firestore email is different from the auth email, update Firestore
        if (firestoreEmail != authEmail) {
          await FirebaseFirestore.instance
              .collection('Users')
              .doc(uid)
              .update({'Email': authEmail});
        }
      } catch (e) {
        if (kDebugMode) {
          print('Failed to update Firestore email: $e');
        }
      }
    }
  }

  /// [Re-Authenticate] - Re-authenticate User
  Future<void> reAuthenticateWithEmailAndPassword(
      String email, String password) async {
    try {
      // Create a credential
      AuthCredential credential =
          EmailAuthProvider.credential(email: email, password: password);

      //ReAuthenticate
      await _auth.currentUser!.reauthenticateWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw MAppFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw MAppFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const MAppFormatException();
    } on PlatformException catch (e) {
      throw MAppPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }

  /* -------------- Federated identity and social sign-in ---------------*/

  /// [Google Authentication] - Google Sign-in
  Future<UserCredential?> signInWithGoogle() async {
    try {
      await GoogleSignIn().signOut();

      // Trigger the authentication flow
      GoogleSignIn signin = GoogleSignIn(scopes: <String>[
        'email',
        'https://www.googleapis.com/auth/userinfo.profile'
      ]);

      final GoogleSignInAccount? userAccount = await signin.signIn();

      // Check if the user canceled the sign-in
      if (userAccount == null) {
        return null; // User canceled the sign-in
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await userAccount.authentication;

      // Create a new credential
      final credentials = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the User Credential
      UserCredential userCredential =
          await _auth.signInWithCredential(credentials);

      // Get the user's email
      String email = userAccount.email;

      // Update Firestore with the user's email
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(userCredential.user?.uid)
          .set({
        'Email': email,
        'DisplayName': userAccount.displayName,
        'ProfilePicture': userAccount.photoUrl,
        'LastActive': Timestamp.now(),
      }, SetOptions(merge: true)); // Use merge to update if exists

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw MAppFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw MAppFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const MAppFormatException();
    } on PlatformException catch (e) {
      throw MAppPlatformException(e.code).message;
    } catch (e) {
      if (kDebugMode) print('Something went wrong: $e');
      return null;
    }
  }

  /// Helper method to check if the email is registered
  Future<bool> isRegisteredEmail(String? email) async {
    if (email != null) {
      try {
        // Query Firestore to check if the email is registered
        final querySnapshot = await FirebaseFirestore.instance
            .collection('Users')
            .where('Email', isEqualTo: email)
            .get();

        // If the query returns any documents, the email is registered
        return querySnapshot.docs.isNotEmpty;
      } catch (e) {
        // Handle any potential errors (e.g., Firestore exception)
        if (kDebugMode) {
          print('Error checking email registration: $e');
        }
        return false;
      }
    } else {
      return false;
    }
  }

  /* ------------ ./end Federated identity and social sign-in -------------*/

  /// [Logout User] - Valid for any authentication
  Future<void> logout() async {
    try {
      await GoogleSignIn().signOut();
      await FirebaseAuth.instance.signOut();
      Get.offAll(() => const LoginScreen());
    } on FirebaseAuthException catch (e) {
      throw MAppFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw MAppFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const MAppFormatException();
    } on PlatformException catch (e) {
      throw MAppPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }

  /// [Delete User] - Remove User Auth and Firestore Account
  Future<void> deleteAccount() async {
    try {
      await UserRepository.instance.removeUserRecord(_auth.currentUser!.uid);
      await _auth.currentUser?.delete();
    } on FirebaseAuthException catch (e) {
      throw MAppFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw MAppFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const MAppFormatException();
    } on PlatformException catch (e) {
      throw MAppPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }

  /// [Delete User Auth] - Remove User Auth Account
  Future<void> deleteUser(String? uid) async {
    if (uid != null) {
      try {
        await FirebaseAuth.instance.currentUser?.delete();
      } catch (e) {
        // Handle error
        if (kDebugMode) {
          print('Error deleting user: $e');
        }
      }
    }
  }
}
