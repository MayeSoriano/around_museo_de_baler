import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/widgets/custom_shapes/containers/circular_container.dart';
import '../../../../../common/widgets/image_text_widgets/rounded_image_text.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../museum_visit_login/screens/qr_code_scanner_screen.dart';
import '../../../controllers/home_banner_slider_controller.dart';

class ScanQRCodeSlider extends StatelessWidget {
  const ScanQRCodeSlider({
    super.key,
    required this.banners,
  });

  final List<Map<String, String>> banners;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeBannerSliderController());

    List<Widget> bannerWidgets = banners.map((banner) {
      return RoundedImageText(
        padding: const EdgeInsets.symmetric(horizontal: MAppSizes.defaultSpace),
        imageUrl: banner['imageUrl'] ?? '',
        title: banner['title'] ?? '',
        subtitle: banner['subtitle'] ?? '',
        onPressed: () => Get.to(() => const QRCodeScannerScreen()),
      );
    }).toList();

    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            viewportFraction: 1,
            aspectRatio: 8 / 5,
            onPageChanged: (index, _) => controller.updatePageIndicator(index),
            autoPlay: true,
            enableInfiniteScroll: true,
            // enlargeCenterPage: true,
            autoPlayInterval: const Duration(seconds: 5),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            scrollDirection: Axis.horizontal,
          ),
          items: bannerWidgets, // Passing the list of Widget objects here
        ),
        const SizedBox(height: MAppSizes.spaceBtwItems),
        Center(
          child: Obx(
            () => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (int i = 0; i < banners.length; i++)
                  CircularContainer(
                    width: 20,
                    height: 4,
                    margin: const EdgeInsets.only(right: 10),
                    backgroundColor: controller.carouselCurrentIndex.value == i
                        ? MAppColors.primary
                        : MAppColors.grey,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
