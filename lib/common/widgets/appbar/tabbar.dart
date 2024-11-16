import 'package:around_museo_de_baler_mobile_app/utils/constants/colors.dart';
import 'package:around_museo_de_baler_mobile_app/utils/device/device_utility.dart';
import 'package:around_museo_de_baler_mobile_app/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class MAppTabBar extends StatelessWidget implements PreferredSizeWidget {
  const MAppTabBar({
    super.key,
    required this.tabs,
  });

  final List<Widget> tabs;

  @override
  Widget build(BuildContext context) {
    final dark = MAppHelperFunctions.isDarkMode(context);

    return Material(
      color: dark ? MAppColors.black : MAppColors.white,
      child: TabBar(
        tabs: tabs,
        isScrollable: true,
        indicatorColor: MAppColors.primary,
        labelColor: dark ? MAppColors.white : MAppColors.primary,
        unselectedLabelColor: MAppColors.darkerGrey,
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(MAppDeviceUtils.getAppBarHeight());
}
