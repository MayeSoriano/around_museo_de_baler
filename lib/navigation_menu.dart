import 'package:around_museo_de_baler_mobile_app/features/main/controllers/location_controller.dart';
import 'package:around_museo_de_baler_mobile_app/features/main/screens/discover/discover.dart';
import 'package:around_museo_de_baler_mobile_app/features/main/screens/home/home.dart';
import 'package:around_museo_de_baler_mobile_app/features/navigation/screens/map.dart';
import 'package:around_museo_de_baler_mobile_app/features/personalization/screens/settings/settings.dart';
import 'package:around_museo_de_baler_mobile_app/utils/constants/colors.dart';
import 'package:around_museo_de_baler_mobile_app/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';


class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    final dark = MAppHelperFunctions.isDarkMode(context);

    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 80,
          elevation: 0,
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index) =>
              controller.selectedIndex.value = index,
          backgroundColor: dark ? MAppColors.black : MAppColors.white,
          indicatorColor: dark
              ? MAppColors.white.withOpacity(0.1)
              : MAppColors.black.withOpacity(0.1),
          destinations: const [
            NavigationDestination(icon: Icon(Iconsax.home), label: 'Home'),
            NavigationDestination(
                icon: Icon(Iconsax.discover), label: 'Discover'),
            NavigationDestination(icon: Icon(Iconsax.map), label: 'Map'),
            NavigationDestination(icon: Icon(Iconsax.user), label: 'Profile'),
          ],
        ),
      ),
      body: Obx(
        () => controller.screens[controller.selectedIndex.value],
      ),
    );
  }
}

class NavigationController extends GetxController {
  static NavigationController get instance => Get.find();
  final locationController =  Get.put(LocationController());
  final Rx<int> selectedIndex = 0.obs;

  final screens = [
    const HomeScreen(),
    const DiscoverScreen(),
    const MapScreen(),
    const SettingsScreen()
  ];
}
