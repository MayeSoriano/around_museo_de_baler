import 'package:around_museo_de_baler_mobile_app/features/main/screens/discover/discover_search.dart';
import 'package:around_museo_de_baler_mobile_app/features/main/screens/discover/widgets/discover_category_tab.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../common/widgets/appbar/tabbar.dart';
import '../../../../common/widgets/locations/favorites/favorites_menu_icon.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../../controllers/location_controller.dart';
import '../favorites/favorites.dart';

class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dark = MAppHelperFunctions.isDarkMode(context);
    final locationController = LocationController.instance;

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: MAppBar(
          title: Text(
            MAppTexts.discoverAppBarTitle,
            style: Theme
                .of(context)
                .textTheme
                .headlineMedium,
          ),
          actions: [
            FavoritesCounterIcon(
              onPressed: () {
                Get.to(() => const FavoriteScreen());
              },
              iconColor: dark ? MAppColors.white : MAppColors.dark,
            ),
          ],
        ),
        body: NestedScrollView(
          headerSliverBuilder: (_, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                automaticallyImplyLeading: false,
                pinned: true,
                floating: true,
                backgroundColor: dark ? MAppColors.black : MAppColors.white,
                expandedHeight: 150,
                flexibleSpace: Padding(
                  padding: const EdgeInsets.all(MAppSizes.defaultSpace),
                  child: ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      // Search Bar
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const DiscoverSearch()),
                          );
                        },
                        child: AbsorbPointer( // Prevents the keyboard from appearing
                          child: TextField(
                            readOnly: true, // Makes the TextField non-editable
                            decoration: InputDecoration(
                              hintText: 'Search Location...',
                              hintStyle: const TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(
                                  color: dark
                                      ? Colors.white.withOpacity(0.4)
                                      : Colors.black.withOpacity(0.4),
                                  width: 1.0,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(
                                  color: dark
                                      ? Colors.white.withOpacity(0.4)
                                      : Colors.black.withOpacity(0.4),
                                  width: 1.0,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(
                                  color: dark
                                      ? Colors.white.withOpacity(0.8)
                                      : Colors.black.withOpacity(0.8),
                                  width: 1.0,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(
                                  color: dark
                                      ? Colors.white.withOpacity(0.4)
                                      : Colors.black.withOpacity(0.4),
                                  width: 1.0,
                                ),
                              ),
                              filled: true,
                              fillColor: dark ? MAppColors.dark : MAppColors
                                  .white,
                              suffixIcon: const Icon(
                                  Icons.search, color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: MAppSizes.spaceBtwSections),
                    ],
                  ),
                ),

                /// Location Categories Tab
                bottom: const MAppTabBar(
                  tabs: [
                    Tab(child: Text('Tourist Spot')),
                    Tab(child: Text('Accommodation')),
                    Tab(child: Text('Dining')),
                    Tab(child: Text('Shopping')),
                  ],
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              DiscoverCategoryTab(
                  categoryId: '2', locations: locationController.touristSpots),
              // CategoryId = 1
              DiscoverCategoryTab(
                  categoryId: '2',
                  locations: locationController.accommodations),
              // CategoryId = 2
              DiscoverCategoryTab(
                  categoryId: '3', locations: locationController.dining),
              // CategoryId = 3
              DiscoverCategoryTab(
                  categoryId: '4', locations: locationController.shopping),
              // CategoryId = 4
            ],
          ),
        ),
      ),
    );
  }
}
