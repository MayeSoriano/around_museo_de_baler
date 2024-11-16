import 'package:around_museo_de_baler_mobile_app/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class MAppBarTheme{
  MAppBarTheme._();

  static const lightAppBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: false,
    scrolledUnderElevation: 0,
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    iconTheme: IconThemeData(
        color: MAppColors.black,
        size: MAppSizes.iconMd,
    ),
    actionsIconTheme: IconThemeData(
        color: MAppColors.black,
        size: MAppSizes.iconMd,
    ),
    titleTextStyle: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.w600,
        color: MAppColors.black
    ),
  );

  static const darkAppBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: false,
    scrolledUnderElevation: 0,
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    iconTheme: IconThemeData(
        color: MAppColors.black,
        size: MAppSizes.iconMd,
    ),
    actionsIconTheme: IconThemeData(
        color: MAppColors.white,
        size: MAppSizes.iconMd,
    ),
    titleTextStyle: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.w600,
        color: MAppColors.white,
    ),
  );
}