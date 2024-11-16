import 'package:around_museo_de_baler_mobile_app/data/repositories/location/location_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../utils/popups/loaders.dart';
import '../models/location_model.dart';

class AllLocationsController extends GetxController {
  static AllLocationsController get instance => Get.find();

  final repository = LocationRepository.instance;

  Future<List<LocationModel>> fetchLocationsByQuery(Query? query) async {
    try {
      if (query == null) return [];

      final locations = await repository.fetchLocationsByQuery(query);

      return locations;
    } catch (e) {
      MAppLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
      return [];
    }
  }
}
