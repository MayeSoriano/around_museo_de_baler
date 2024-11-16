import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';

import '../../../../../common/widgets/images/rounded_image.dart';
import '../../../controllers/location_image_slider_controller.dart';

class LocationImageSlider extends StatelessWidget {
  const LocationImageSlider({
    super.key,
    required this.locations,
  });

  final List<Map<String, String>> locations;

  @override
  Widget build(BuildContext context) {
    final imageSliderController = Get.put(LocationImageSliderController());

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        CarouselSlider.builder(
          options: CarouselOptions(
            viewportFraction: 1,
            autoPlay: true,
            pauseAutoPlayOnTouch: true,
            enableInfiniteScroll: false,
            height: 400,
            onPageChanged: (index, _) =>
                imageSliderController.updatePageIndicator(index),
          ),
          itemCount: locations.length,
          itemBuilder: (context, index, _) {
            final location = locations[index];
            return GestureDetector(
              onTap: () {
                final multiImageProvider = MultiImageProvider([
                  NetworkImage(location['imageUrl'] ?? ''),
                  // Add more images if needed
                ]);
                showImageViewerPager(
                  context,
                  multiImageProvider,
                  onPageChanged: (page) {
                    imageSliderController.updatePageIndicator(page);
                  },
                  onViewerDismissed: (page) {
                    if (kDebugMode) {
                      print("dismissed while on page $page");
                    }
                  },
                );
              },
              child: RoundedImage(
                width: double.infinity,
                height: 400,
                isNetworkImage: true,
                imageUrl: location['imageUrl'] ?? '',
                borderRadius: 0,
                fit: BoxFit.cover,
                onPressed: () {},
              ),
            );
          },
        ),
        if (locations.length > 1) // Conditional rendering for pagination
          Padding(
            padding: const EdgeInsets.only(bottom: 40.0),
            child: Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  locations.length,
                  (index) => Container(
                    width: 8.0,
                    height: 8.0,
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: imageSliderController.carouselCurrentIndex.value ==
                              index
                          ? Colors.white
                          : Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
