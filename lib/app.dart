import 'package:around_museo_de_baler_mobile_app/routes/app_routes.dart';
import 'package:around_museo_de_baler_mobile_app/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:around_museo_de_baler_mobile_app/utils/theme/theme.dart';
import 'package:around_museo_de_baler_mobile_app/utils/constants/text_strings.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'bindings/general_bindings.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: true,
      title: MAppTexts.appName,
      themeMode: ThemeMode.system,
      theme: MAppTheme.lightTheme,
      darkTheme: MAppTheme.darkTheme,
      initialBinding: GeneralBindings(),
      getPages: AppRoutes.pages,
      /// Show Loader or Circular Progress Indicator meanwhile Authentication Repository is deciding which relevant screen to show.
      home: const Scaffold(
          backgroundColor: MAppColors.primary,
          body: Center(
              child: CircularProgressIndicator(
                  color: MAppColors.white,
              ),
          ),
      ),
    );
  }
}