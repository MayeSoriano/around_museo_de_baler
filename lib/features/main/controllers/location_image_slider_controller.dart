import 'package:carousel_slider/carousel_controller.dart';
import 'package:get/get.dart';

class LocationImageSliderController extends GetxController {
  static LocationImageSliderController get instance => Get.find();

  // Location Image Slider Variables
  final carouselCurrentIndex = 0.obs;
  final CarouselSliderController carouselController =
      CarouselSliderController();
  // Pagination Variables
  final currentPage = 0.obs;

  // Image Slider Methods
  void updatePageIndicator(index) {
    carouselCurrentIndex.value = index;
  }

  void updatePhotoViewPageIndicator(index) {
    currentPage.value = index;
  }

  void goToPreviousPage() {
    carouselController.previousPage();
  }

  void goToNextPage() {
    carouselController.nextPage();
  }
}
