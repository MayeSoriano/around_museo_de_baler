import 'package:around_museo_de_baler_mobile_app/data/repositories/location_categories/location_category_repository.dart';
import 'package:get/get.dart';

import '../../../utils/popups/loaders.dart';
import '../models/location_category_model.dart';

class LocationCategoryController extends GetxController {
  static LocationCategoryController get instance => Get.find();

  final isLoading = false.obs;
  final _locationCategoryRepository = Get.put(LocationCategoryRepository());
  RxList<LocationCategoryModel> allLocationCategories = <LocationCategoryModel>[].obs;
  RxList<LocationCategoryModel> featuredCategories = <LocationCategoryModel>[].obs;

  @override
  void onInit() {
    fetchLocationCategory();
    super.onInit();
  }

  /// Load location category data
  Future<void> fetchLocationCategory() async {
    try {
      // Show loader while loading categories
      isLoading.value = true;

      // Fetch categories from data source (Firestore)
      final locationCategories = await _locationCategoryRepository.getAllCategories();

      // Update the categories list
      allLocationCategories.assignAll(locationCategories);

      // Filter featured categories (Parent Categories)
      featuredCategories.assignAll(allLocationCategories.where((locationCategory) => locationCategory.parentId.isEmpty).toList());
    } catch (e) {
      MAppLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    } finally {
      // Remove loader
      isLoading.value = false;
    }
  }

  /// Load selected location category data


  /// Get category or sub-category locations

}