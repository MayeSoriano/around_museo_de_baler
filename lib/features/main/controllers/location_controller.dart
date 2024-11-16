import 'dart:async';

import 'package:around_museo_de_baler_mobile_app/features/main/models/location_model.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../data/repositories/location/location_repository.dart';
import '../../../utils/popups/loaders.dart';

class LocationController extends GetxController {
  static LocationController get instance => Get.find();

  /// Variables
  final isLoading = false.obs;
  final locationRepository = Get.put(LocationRepository());
  RxList<LocationModel> allLocations = <LocationModel>[].obs;
  RxList<LocationModel> featuredLocations = <LocationModel>[].obs;
  RxList<LocationModel> touristSpots = <LocationModel>[].obs;
  RxList<LocationModel> accommodations = <LocationModel>[].obs;
  RxList<LocationModel> dining = <LocationModel>[].obs;
  RxList<LocationModel> shopping = <LocationModel>[].obs;
  RxList<LocationModel> favoriteLocations = <LocationModel>[].obs;
  RxSet<String> favoriteLocationIds = <String>{}.obs;
  final RxBool showOperatingHours = false.obs;
  Timer? _updateTimer;

  @override
  void onInit() async {
    // Run all fetch functions in parallel
    await Future.wait([
      fetchFeaturedLocations(),
      fetchTouristSpots(),
      fetchAccommodations(),
      fetchDining(),
      fetchShopping(),
    ]);
    fetchUserFavorites();
    super.onInit();
  }


  @override
  void onClose() {
    _updateTimer?.cancel();
    super.onClose();
  }

  /// Show Operating Hours Method
  void toggleOperatingHours() {
    showOperatingHours.toggle();
  }

  Future<void> fetchFeaturedLocations() async {
    try {
      // Show loader while loading locations
      isLoading.value = true;

      // Fetch featured locations
      featuredLocations
          .assignAll(await locationRepository.getFeaturedLocations());

      // Fetch and set category names for featured locations
      await Future.wait(featuredLocations.map((location) async {
        final categoryName =
            await locationRepository.getCategoryNameById(location.categoryId);
        final subCategoryName = await locationRepository
            .getCategoryNameById(location.subCategoryId);
        location.categoryName = categoryName;
        location.subCategoryName = subCategoryName;

        location.isOpen = checkIfLocationIsOpen(location.operatingHours);
        location.openTimes = whenToOpen(location.operatingHours);
        location.closeTimes = whenToClose(location.operatingHours);
      }));
    } catch (e) {
      MAppLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    } finally {
      // Remove loader
      isLoading.value = false;
    }
  }

  Future<void> fetchTouristSpots() async {
    try {
      isLoading.value = true;
      touristSpots
          .assignAll(await locationRepository.getLocationsByCategory('1'));
      await setLocationsDetails(touristSpots);
      allLocations.addAll(touristSpots);
    } catch (e) {
      MAppLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchAccommodations() async {
    try {
      isLoading.value = true;
      accommodations
          .assignAll(await locationRepository.getLocationsByCategory('2'));
      await setLocationsDetails(accommodations);
      allLocations.addAll(accommodations);
    } catch (e) {
      MAppLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchDining() async {
    try {
      isLoading.value = true;
      dining.assignAll(await locationRepository.getLocationsByCategory('3'));
      await setLocationsDetails(dining);
    } catch (e) {
      MAppLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchShopping() async {
    try {
      isLoading.value = true;
      shopping.assignAll(await locationRepository.getLocationsByCategory('4'));
      await setLocationsDetails(shopping);
      allLocations.addAll(shopping);
    } catch (e) {
      MAppLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> setLocationsDetails(RxList<LocationModel> locations) async {
    await Future.forEach(locations, (LocationModel location) async {
      await setLocationCategory(location);

      location.isOpen = checkIfLocationIsOpen(location.operatingHours);
      location.openTimes = whenToOpen(location.operatingHours);
      location.closeTimes = whenToClose(location.operatingHours);
    });
  }

  Future<void> fetchAllLocations() async {
    try {
      isLoading.value = true;

      allLocations.assignAll(await locationRepository.getAllLocations());

      await Future.forEach(allLocations, (LocationModel location) async {
        await setLocationCategory(location);

        // Set location isOpen, openTimes, and closeTimes
        location.isOpen = checkIfLocationIsOpen(location.operatingHours);
        location.openTimes = whenToOpen(location.operatingHours);
        location.closeTimes = whenToClose(location.operatingHours);
      });

      // Filter locations into different categories
      touristSpots.assignAll(
          allLocations.where((location) => location.categoryId == '1'));
      accommodations.assignAll(
          allLocations.where((location) => location.categoryId == '2'));
      dining.assignAll(
          allLocations.where((location) => location.categoryId == '3'));
      shopping.assignAll(
          allLocations.where((location) => location.categoryId == '4'));
    } catch (e) {
      MAppLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> setLocationCategory(LocationModel location) async {
    final categoryName =
        await locationRepository.getCategoryNameById(location.categoryId);
    final subCategoryName =
        await locationRepository.getCategoryNameById(location.subCategoryId);
    location.categoryName = categoryName;
    location.subCategoryName = subCategoryName;
  }

  bool checkIfLocationIsOpen(Map<String, String>? operatingHours) {
    final DateTime now = DateTime.now();
    String currentDay = DateFormat('E').format(now);

    if (operatingHours == null ||
        operatingHours[currentDay] == null ||
        operatingHours[currentDay]!.isEmpty) {
      return false; // Location is closed if schedule for current day is missing or empty
    }

    final List<String> hours = operatingHours[currentDay]!.split('-');
    final DateTime openTime = parseTimeString(hours[0].trim());
    final DateTime closeTime = parseTimeString(hours[1].trim());

    int currentHour = now.hour;
    int openHour = openTime.hour;
    int closeHour = closeTime.hour;

    return currentHour >= openHour && currentHour < closeHour;
  }

  String whenToOpen(Map<String, String>? operatingHours) {
    final DateTime now = DateTime.now();
    String currentDay = DateFormat('E').format(now);

    if (operatingHours == null ||
        operatingHours[currentDay] == null ||
        operatingHours[currentDay]!.isEmpty) {
      // If the current day's schedule is missing or empty, find the next opening time
      for (int i = 1; i <= 7; i++) {
        String nextDay = DateFormat('E').format(now.add(Duration(days: i)));

        if (operatingHours!.containsKey(nextDay) &&
            operatingHours[nextDay] != null &&
            operatingHours[nextDay]!.isNotEmpty) {
          final List<String> nextDayHours = operatingHours[nextDay]!.split('-');
          final String nextDayTime = nextDayHours[0].trim();
          return '$nextDay, $nextDayTime';
        }
      }
      return 'Closed'; // If no opening time is found for the next 7 days, consider the location closed
    }

    final List<String> hours = operatingHours[currentDay]!.split('-');
    final DateTime openTime = parseTimeString(hours[0].trim());

    int currentHour = now.hour;
    int openHour = openTime.hour;

    if (currentHour < openHour) {
      return '$currentDay, ${DateFormat.jm().format(openTime)}';
    }

    // Location is already open, find the next opening time
    for (int i = 1; i <= 7; i++) {
      String nextDay = DateFormat('E').format(now.add(Duration(days: i)));

      if (operatingHours.containsKey(nextDay) &&
          operatingHours[nextDay] != null &&
          operatingHours[nextDay]!.isNotEmpty) {
        final List<String> nextDayHours = operatingHours[nextDay]!.split('-');
        final String nextDayTime = nextDayHours[0].trim();
        return '$nextDay, $nextDayTime';
      }
    }

    return 'Closed'; // If no opening time is found for the next 7 days, consider the location closed
  }

  String whenToClose(Map<String, String>? operatingHours) {
    final DateTime now = DateTime.now();
    String currentDay = DateFormat('E').format(now);

    if (operatingHours == null ||
        operatingHours[currentDay] == null ||
        operatingHours[currentDay]!.isEmpty) {
      return 'Closed'; // Location is closed if schedule for current day is missing or empty
    }

    final List<String> hours = operatingHours[currentDay]!.split('-');
    final DateTime closeTime = parseTimeString(hours[1].trim());

    int currentHour = now.hour;
    int closeHour = closeTime.hour;

    if (currentHour < closeHour) {
      return '$currentDay, ${DateFormat.jm().format(closeTime)}';
    }

    // Location is already closed, find next closing time
    for (int i = 1; i <= 7; i++) {
      String nextDay = DateFormat('E').format(now.add(Duration(days: i)));

      if (operatingHours.containsKey(nextDay) &&
          operatingHours[nextDay] != null &&
          operatingHours[nextDay]!.isNotEmpty) {
        final List<String> nextDayHours = operatingHours[nextDay]!.split('-');
        final String nextDayTime = nextDayHours[1].trim();
        return '$nextDay, $nextDayTime';
      }
    }
    return '';
  }

  String formatOperatingHours(Map<String, String>? operatingHours) {
    if (operatingHours == null || operatingHours.isEmpty) {
      return 'No operating hours available';
    }

    // Define the order of days
    final daysOrder = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    // Sort the entries based on the order of days
    final sortedEntries = daysOrder.map((day) {
      final hours = operatingHours[day] ?? '';
      // Check if operating hours for the day are empty
      if (hours.isEmpty) {
        return MapEntry(day, 'Closed');
      }
      return MapEntry(day, hours);
    }).toList();

    // Format the operating hours
    final formattedOperatingHours =
        sortedEntries.map((entry) => '${entry.key}: ${entry.value}').join('\n');

    return formattedOperatingHours;
  }

  DateTime parseTimeString(String timeString) {
    // Parse time string with AM/PM and return a DateTime object
    return DateFormat('yyyy-MM-dd hh:mm a').parse('2022-01-01 $timeString');
  }

  Future<void> fetchUserFavorites() async {
    try {
      isLoading.value = true;

      // Get user favorites (locationIds) from User_Favorites collection
      final userFavorites = await locationRepository.getUserFavorites();
      if (userFavorites != null) {
        favoriteLocationIds.value = userFavorites.favoriteLocationIds.toSet(); // Update Set

        // Update favoriteLocations based on the current user favorites
        favoriteLocations.assignAll(allLocations.where((location) => favoriteLocationIds.contains(location.id)));
      }
    } catch (e) {
      MAppLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleFavorite(String locationId) async {
    if (favoriteLocationIds.contains(locationId)) {
      // Remove from favorites
      favoriteLocationIds.remove(locationId);
      await locationRepository.removeFromFavorites(locationId);
    } else {
      // Add to favorites
      favoriteLocationIds.add(locationId);
      await locationRepository.addToFavorites(locationId);
    }

    // Update favoriteLocations based on the current set of IDs
    favoriteLocations.assignAll(allLocations.where((location) => favoriteLocationIds.contains(location.id)));

    // Optionally, you can call fetchUserFavorites to refresh from the DB
    // await fetchUserFavorites();
  }
}
