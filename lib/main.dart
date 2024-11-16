import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';

import '../app.dart';
import '../data/repositories/authentication/authentication_repository.dart';
import '../firebase_options.dart';

/// ---------- Entry Point of Flutter App ----------
Future<void> main() async {
  // Widget Binding
  final WidgetsBinding widgetsBinding =
      WidgetsFlutterBinding.ensureInitialized();

  // Initialize Local Storage
  // await GetStorage.init();

  // Await Native Splash
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .then((FirebaseApp app) {
    // Initialize App Check
    FirebaseAppCheck.instance.activate(
      androidProvider:
          AndroidProvider.debug, // Use 'playIntegrity' for production
      appleProvider:
          AppleProvider.appAttestWithDeviceCheckFallback, // App Attest for iOS
    );

    // Put Authentication Repository in GetX dependency injection
    Get.put(AuthenticationRepository());
  });

  // Portrait Orientation
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const App());
  });
}
