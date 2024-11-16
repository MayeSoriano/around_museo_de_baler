import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../features/main/models/location_category_model.dart';
import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';

class LocationCategoryRepository extends GetxController {
  static LocationCategoryRepository get instance => Get.find();

  /// Variables
  final _db = FirebaseFirestore.instance;

  /// Get all location categories
  Future<List<LocationCategoryModel>> getAllCategories() async {
    try {
      final snapshot = await _db.collection('Location_Categories').get();
      final list = snapshot.docs
          .map((document) => LocationCategoryModel.fromSnapshot(document))
          .toList();
      return list;
    } on FirebaseException catch (e) {
      throw MAppFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw MAppPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }

  /// Get sub-categories

  /// Upload categories to the cloud firebase
}
