import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/sizes.dart';

class MAppOutlinedButtonTheme {
  MAppOutlinedButtonTheme._();

  static final lightOutlinedButtonTheme  = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      elevation: 0,
      foregroundColor: MAppColors.dark,
      side: const BorderSide(color: MAppColors.borderPrimary),
      textStyle: const TextStyle(fontSize: 16, color: MAppColors.black, fontWeight: FontWeight.w600),
      padding: const EdgeInsets.symmetric(vertical: MAppSizes.buttonHeight, horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(MAppSizes.buttonRadius)),
    ),
  );

  static final darkOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: MAppColors.light,
      side: const BorderSide(color: MAppColors.borderPrimary),
      textStyle: const TextStyle(fontSize: 16, color: MAppColors.textWhite, fontWeight: FontWeight.w600),
      padding: const EdgeInsets.symmetric(vertical: MAppSizes.buttonHeight, horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(MAppSizes.buttonRadius)),
    ),
  );
}
