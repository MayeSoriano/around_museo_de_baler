import 'package:flutter/material.dart';

import '../../utils/constants/colors.dart';

class ShadowStyle {
  static final locationShadow = BoxShadow(
      color: MAppColors.darkGrey.withOpacity(0.1),
      blurRadius: 50,
      spreadRadius: 7,
      offset: const Offset(0, 2));
}
