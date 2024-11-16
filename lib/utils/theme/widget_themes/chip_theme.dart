import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class MAppChipTheme {
  MAppChipTheme._();

  static ChipThemeData lightChipTheme = ChipThemeData(
    disabledColor: MAppColors.grey.withOpacity(0.4),
    labelStyle: const TextStyle(color: MAppColors.black),
    selectedColor: MAppColors.primary,
    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
    checkmarkColor: MAppColors.white,
  );

  static ChipThemeData darkChipTheme = const ChipThemeData(
    disabledColor: MAppColors.darkerGrey,
    labelStyle: TextStyle(color: MAppColors.white),
    selectedColor: MAppColors.primary,
    padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
    checkmarkColor: MAppColors.white,
  );
}
