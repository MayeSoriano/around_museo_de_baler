import 'package:around_museo_de_baler_mobile_app/features/augmented_reality/screens/ar_content_camera_screen.dart';
import 'package:around_museo_de_baler_mobile_app/features/authentication/screens/login/login.dart';
import 'package:around_museo_de_baler_mobile_app/features/authentication/screens/onboarding/onboarding.dart';
import 'package:around_museo_de_baler_mobile_app/features/authentication/screens/password_configuration/forgot_password.dart';
import 'package:around_museo_de_baler_mobile_app/features/authentication/screens/signup/signup.dart';
import 'package:around_museo_de_baler_mobile_app/features/authentication/screens/signup/verify_email.dart';
import 'package:around_museo_de_baler_mobile_app/features/museum_visit_login/screens/qr_code_scanner_screen.dart';
import 'package:around_museo_de_baler_mobile_app/routes/routes.dart';
import 'package:get/get.dart';

import '../features/main/screens/home/home.dart';
import '../features/main/screens/search/search.dart';
import '../features/navigation/screens/map.dart';
import '../features/personalization/screens/profile/profile.dart';
import '../features/personalization/screens/settings/settings.dart';

class AppRoutes {
  static final pages = [
    GetPage(name: MAppRoutes.home, page: () => const HomeScreen()),
    //GetPage(name: MAppRoutes.discover, page: () => const DiscoverScreen()),
    //GetPage(name: MAppRoutes.favorites, page: () => const FavoriteScreen()),
    GetPage(name: MAppRoutes.map, page: () => MapScreen()),
    GetPage(name: MAppRoutes.search, page: () => const SearchScreen()),
    GetPage(name: MAppRoutes.profile, page: () => const ProfileScreen()),
    GetPage(name: MAppRoutes.settings, page: () => const SettingsScreen()),
    GetPage(name: MAppRoutes.onBoarding, page: () => const OnBoardingScreen()),
    GetPage(name: MAppRoutes.signUp, page: () => const SignupScreen()),
    GetPage(name: MAppRoutes.verifyEmail, page: () => const VerifyEmailScreen()),
    GetPage(name: MAppRoutes.login, page: () => const LoginScreen()),
    GetPage(name: MAppRoutes.forgotPassword, page: () => const ForgotPasswordScreen()),
    GetPage(name: MAppRoutes.qrCodeScanner, page: () => const QRCodeScannerScreen()),
    GetPage(name: MAppRoutes.arContentCamera, page: () => ArContentCameraScreen()),
  ];
}