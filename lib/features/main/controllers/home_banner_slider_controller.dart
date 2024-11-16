import 'package:get/get.dart';


class HomeBannerSliderController extends GetxController {
  static HomeBannerSliderController get instance => Get.find();

  /// Variables
  final carouselCurrentIndex = 0.obs;

  /// Update Page Navigational Dots
  void updatePageIndicator(index) {
    carouselCurrentIndex.value = index;
  }
}