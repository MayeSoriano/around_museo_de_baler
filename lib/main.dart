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
  try {
    // Widget Binding
    final WidgetsBinding widgetsBinding =
        WidgetsFlutterBinding.ensureInitialized();

    // Await Native Splash
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Initialize App Check
    await FirebaseAppCheck.instance.activate(
      androidProvider: AndroidProvider.debug,
      appleProvider: AppleProvider.appAttestWithDeviceCheckFallback,
    );

    // Initialize Authentication Repository
    Get.put(AuthenticationRepository());

    // Portrait Orientation
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    runApp(const App());
  } catch (e) {
    print('Initialization Error: $e');
    // Handle initialization errors appropriately
  }
}
