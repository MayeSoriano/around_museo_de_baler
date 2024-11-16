import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/sizes.dart';

class MAppTextFormFieldTheme {
  MAppTextFormFieldTheme._();

  static InputDecorationTheme lightInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 3,
    prefixIconColor: MAppColors.darkGrey,
    suffixIconColor: MAppColors.darkGrey,
    // constraints: const BoxConstraints.expand(height: TSizes.inputFieldHeight),
    labelStyle: const TextStyle().copyWith(fontSize: MAppSizes.fontSizeSm, color: MAppColors.black),
    hintStyle: const TextStyle().copyWith(fontSize: MAppSizes.fontSizeSm, color: MAppColors.black),
    errorStyle: const TextStyle().copyWith(
      fontStyle: FontStyle.normal,
      fontSize: 12.0,
    ),
    floatingLabelStyle: const TextStyle().copyWith(color: MAppColors.black.withOpacity(0.8)),
    border: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(MAppSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: MAppColors.grey),
    ),
    enabledBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(MAppSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: MAppColors.grey),
    ),
    focusedBorder:const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(MAppSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: MAppColors.dark),
    ),
    errorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(MAppSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: MAppColors.warning),
    ),
    focusedErrorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(MAppSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 2, color: MAppColors.warning),
    ),
  );

  static InputDecorationTheme darkInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 2,
    prefixIconColor: MAppColors.darkGrey,
    suffixIconColor: MAppColors.darkGrey,
    // constraints: const BoxConstraints.expand(height: TSizes.inputFieldHeight),
    labelStyle: const TextStyle().copyWith(fontSize: MAppSizes.fontSizeSm, color: MAppColors.white),
    hintStyle: const TextStyle().copyWith(fontSize: MAppSizes.fontSizeSm, color: MAppColors.white),
    floatingLabelStyle: const TextStyle().copyWith(color: MAppColors.white.withOpacity(0.8)),
    errorStyle: const TextStyle().copyWith(
      fontStyle: FontStyle.normal,
      fontSize: 12.0,
    ),
    border: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(MAppSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: MAppColors.darkGrey),
    ),
    enabledBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(MAppSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: MAppColors.darkGrey),
    ),
    focusedBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(MAppSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: MAppColors.white),
    ),
    errorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(MAppSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: MAppColors.warning),
    ),
    focusedErrorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(MAppSizes.inputFieldRadius),
      borderSide: const BorderSide(width: 2, color: MAppColors.warning),
    ),
  );
}
