import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/sizes.dart';

class MAppElevatedButtonTheme {
  MAppElevatedButtonTheme._();

  static final lightElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: MAppColors.light,
      backgroundColor: MAppColors.primary,
      disabledForegroundColor: MAppColors.darkerGrey,
      disabledBackgroundColor: MAppColors.buttonDisabled,
      side: const BorderSide(color: MAppColors.primary),
      padding: const EdgeInsets.symmetric(vertical: MAppSizes.buttonHeight),
      textStyle: const TextStyle(
          fontSize: 16,
          color: MAppColors.white,
          fontWeight: FontWeight.w600
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(MAppSizes.buttonRadius)),
    ),
  );

  static final darkElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: MAppColors.light,
      backgroundColor: MAppColors.primary,
      disabledForegroundColor: MAppColors.darkGrey,
      disabledBackgroundColor: MAppColors.darkerGrey,
      side: const BorderSide(color: Colors.blue),
      padding: const EdgeInsets.symmetric(vertical: MAppSizes.buttonHeight),
      textStyle: const TextStyle(
          fontSize: 16,
          color: MAppColors.white,
          fontWeight: FontWeight.w600
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(MAppSizes.buttonRadius)),
    ),
  );
}