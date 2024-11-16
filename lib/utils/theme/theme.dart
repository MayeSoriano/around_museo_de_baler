import 'package:around_museo_de_baler_mobile_app/utils/theme/widget_themes/appbar_theme.dart';
import 'package:around_museo_de_baler_mobile_app/utils/theme/widget_themes/bottom_sheet_theme.dart';
import 'package:around_museo_de_baler_mobile_app/utils/theme/widget_themes/checkbox_theme.dart';
import 'package:around_museo_de_baler_mobile_app/utils/theme/widget_themes/chip_theme.dart';
import 'package:around_museo_de_baler_mobile_app/utils/theme/widget_themes/elevated_button_theme.dart';
import 'package:around_museo_de_baler_mobile_app/utils/theme/widget_themes/outlined_button_theme.dart';
import 'package:around_museo_de_baler_mobile_app/utils/theme/widget_themes/text_field_theme.dart';
import 'package:around_museo_de_baler_mobile_app/utils/theme/widget_themes/text_theme.dart';
import 'package:flutter/material.dart';

import '../constants/colors.dart';

class MAppTheme {
  MAppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    primarySwatch: Colors.blue,
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: MAppColors.primary, // Customize the color of the progress indicators
    ),
    brightness: Brightness.light,
    primaryColor: MAppColors.primary,
    textTheme: MAppTextTheme.lightTextTheme,
    chipTheme: MAppChipTheme.lightChipTheme,
    scaffoldBackgroundColor: MAppColors.white,
    appBarTheme: MAppBarTheme.lightAppBarTheme,
    checkboxTheme: MAppCheckboxTheme.lightCheckboxTheme,
    bottomSheetTheme: MAppBottomSheetTheme.lightBottomSheetTheme,
    elevatedButtonTheme: MAppElevatedButtonTheme.lightElevatedButtonTheme,
    outlinedButtonTheme: MAppOutlinedButtonTheme.lightOutlinedButtonTheme,
    inputDecorationTheme: MAppTextFormFieldTheme.lightInputDecorationTheme,
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    primarySwatch: Colors.blue,
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: MAppColors.primary, // Customize the color of the progress indicators
    ),
    brightness: Brightness.dark,
    primaryColor: MAppColors.primary,
    textTheme: MAppTextTheme.darkTextTheme,
    chipTheme: MAppChipTheme.darkChipTheme,
    scaffoldBackgroundColor: MAppColors.black,
    appBarTheme: MAppBarTheme.darkAppBarTheme,
    checkboxTheme: MAppCheckboxTheme.darkCheckboxTheme,
    bottomSheetTheme: MAppBottomSheetTheme.darkBottomSheetTheme,
    elevatedButtonTheme: MAppElevatedButtonTheme.darkElevatedButtonTheme,
    outlinedButtonTheme: MAppOutlinedButtonTheme.darkOutlinedButtonTheme,
    inputDecorationTheme: MAppTextFormFieldTheme.darkInputDecorationTheme,
  );
}