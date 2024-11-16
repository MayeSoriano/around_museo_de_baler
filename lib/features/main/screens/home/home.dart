import 'package:around_museo_de_baler_mobile_app/features/main/screens/home/widgets/home_appbar.dart';
import 'package:around_museo_de_baler_mobile_app/features/main/screens/home/widgets/home_locations_horizontal_listview.dart';
import 'package:around_museo_de_baler_mobile_app/features/main/screens/home/widgets/home_banner_slider.dart';
import 'package:flutter/material.dart';

import '../../../../common/widgets/custom_shapes/containers/primary_header_container.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../../utils/constants/sizes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            PrimaryHeaderContainer(
              child: Column(
                children: [
                  /// AppBar
                  HomeAppBar(),
                  SizedBox(height: MAppSizes.spaceBtwItems),
                ],
              ),
            ),

            /// Body
            Column(
              children: [
                /// Scan QR Code
                ScanQRCodeSlider(
                  banners: [
                    {
                      'imageUrl': MAppImages.homeScanQRBg1,
                      'title': MAppTexts.scanQRTitle1,
                      'subtitle': MAppTexts.scanQRSubtitle,
                    },
                    {
                      'imageUrl': MAppImages.homeScanQRBg2,
                      'title': MAppTexts.scanQRTitle2,
                      'subtitle': MAppTexts.scanQRSubtitle,
                    },
                    {
                      'imageUrl': MAppImages.homeScanQRBg3,
                      'title': MAppTexts.scanQRTitle3,
                      'subtitle': MAppTexts.scanQRSubtitle,
                    },
                  ],
                ),
                SizedBox(height: MAppSizes.spaceBtwSections),

                /// Locations
                LocationsHorizontalListView(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
