import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../features/augmented_reality/models/museum_item_model.dart';
import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';

/// Repository for managing Museum Item-related data and operations
class MuseumItemRepository extends GetxController {
  static MuseumItemRepository get instance => Get.find();

  /// Firestore instance fore database interactions
  final _db = FirebaseFirestore.instance;

  /// Get all locations
  Future<List<MuseumItemModel>> getAllMuseumItems() async {
    try {
      final snapshot = await _db
          .collection('Museum_Items')
          .get();
      return snapshot.docs.map((e) => MuseumItemModel.fromSnapshot(e)).toList();
    } on FirebaseException catch (e) {
      throw MAppFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw MAppPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }

  /// Get locations by query
  Future<List<MuseumItemModel>> fetchMuseumItemsByQuery(Query query) async {
    try {
      final querySnapshot = await query.get();
      final List<MuseumItemModel> museumItemsList = querySnapshot.docs
          .map((doc) => MuseumItemModel.fromQuerySnapshot(doc))
          .toList();
      return museumItemsList;
    } on FirebaseException catch (e) {
      throw MAppFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw MAppPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }

  /// Get locations by category
  Future<List<MuseumItemModel>> getMuseumItemsByCategory(String categoryId) async {
    try {
      final snapshot = await _db
          .collection('Museum_Items')
          .where('CategoryId', isEqualTo: categoryId)
          .get();
      return snapshot.docs.map((e) => MuseumItemModel.fromSnapshot(e)).toList();
    } on FirebaseException catch (e) {
      throw MAppFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw MAppPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }

  /// Get Category Name based on the Category Id
  Future<String> getCategoryNameById(String categoryId) async {
    try {
      final snapshot =
      await _db.collection('Museum_Item_Categories').doc(categoryId).get();

      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        return data['Name'] ?? '';
      } else {
        return ''; // when the category doesn't exist
      }
    } on FirebaseException catch (e) {
      throw MAppFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw MAppPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }
}
