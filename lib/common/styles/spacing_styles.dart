import 'package:flutter/material.dart';

import '../../utils/constants/sizes.dart';

class MAppSpacingStyle {
  static const EdgeInsetsGeometry paddingWithAppBarHeight = EdgeInsets.only(
    top: MAppSizes.appBarHeight,
    left: MAppSizes.defaultSpace,
    bottom: MAppSizes.defaultSpace,
    right: MAppSizes.defaultSpace,
  );
}
