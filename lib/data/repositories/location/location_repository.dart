import 'package:around_museo_de_baler_mobile_app/features/main/models/location_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../features/main/models/user_favorites_location_model.dart';
import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';

/// Repository for managing location-related data and operations
class LocationRepository extends GetxController {
  static LocationRepository get instance => Get.find();

  /// Firestore instance fore database interactions
  final _db = FirebaseFirestore.instance;
  String? userId = FirebaseAuth.instance.currentUser?.uid;

  /// Get limited featured locations
  Future<List<LocationModel>> getFeaturedLocations() async {
    try {
      final snapshot = await _db
          .collection('Locations')
          .where('IsFeatured', isEqualTo: true)
          .limit(5)
          .get();
      return snapshot.docs.map((e) => LocationModel.fromSnapshot(e)).toList();
    } on FirebaseException catch (e) {
      throw MAppFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw MAppPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }

  /// Get all featured locations
  Future<List<LocationModel>> getAllFeaturedLocations() async {
    try {
      final snapshot = await _db
          .collection('Locations')
          .where('IsFeatured', isEqualTo: true)
          .get();
      return snapshot.docs.map((e) => LocationModel.fromSnapshot(e)).toList();
    } on FirebaseException catch (e) {
      throw MAppFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw MAppPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }

  /// Get all locations
  Future<List<LocationModel>> getAllLocations() async {
    try {
      final snapshot = await _db
          .collection('Locations')
          .get();
      return snapshot.docs.map((e) => LocationModel.fromSnapshot(e)).toList();
    } on FirebaseException catch (e) {
      throw MAppFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw MAppPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }

  /// Get locations by query
  Future<List<LocationModel>> fetchLocationsByQuery(Query query) async {
    try {
      final querySnapshot = await query.get();
      final List<LocationModel> locationList = querySnapshot.docs
          .map((doc) => LocationModel.fromQuerySnapshot(doc))
          .toList();
      return locationList;
    } on FirebaseException catch (e) {
      throw MAppFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw MAppPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }

  /// Get locations by category
  Future<List<LocationModel>> getLocationsByCategory(String categoryId) async {
    try {
      final snapshot = await _db
          .collection('Locations')
          .where('CategoryId', isEqualTo: categoryId)
          .get();
      return snapshot.docs.map((e) => LocationModel.fromSnapshot(e)).toList();
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
          await _db.collection('Location_Categories').doc(categoryId).get();

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

  /// Get user favorites
  Future<UserFavoritesLocationModel?> getUserFavorites() async {
    try {
      final snapshot = await _db.collection('User_Favorites').doc(userId).get();
      if (snapshot.exists) {
        return UserFavoritesLocationModel.fromSnapshot(snapshot);
      }
      return null; // No favorites found for the user
    } on FirebaseException catch (e) {
      throw MAppFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw MAppPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }

  Future<void> addToFavorites(String locationId) async {
    final userFavoritesRef = _db.collection('User_Favorites').doc(userId);

    // Use a transaction to ensure atomicity
    await _db.runTransaction((transaction) async {
      final snapshot = await transaction.get(userFavoritesRef);
      if (!snapshot.exists) {
        // If the document doesn't exist, create it with the locationId
        transaction.set(userFavoritesRef, {
          'FavoriteLocationIds': [locationId],
        });
      } else {
        // If it exists, update the favoriteLocationIds array
        List<dynamic> favoriteLocationIds = snapshot.data()?['FavoriteLocationIds'] ?? [];
        if (!favoriteLocationIds.contains(locationId)) {
          favoriteLocationIds.add(locationId);
          transaction.update(userFavoritesRef, {
            'FavoriteLocationIds': favoriteLocationIds,
          });
        }
      }
    });
  }

  Future<void> removeFromFavorites(String locationId) async {
    final userFavoritesRef = _db.collection('User_Favorites').doc(userId);

    // Use a transaction to ensure atomicity
    await _db.runTransaction((transaction) async {
      final snapshot = await transaction.get(userFavoritesRef);
      if (snapshot.exists) {
        List<dynamic> favoriteLocationIds = snapshot.data()?['FavoriteLocationIds'] ?? [];
        if (favoriteLocationIds.contains(locationId)) {
          favoriteLocationIds.remove(locationId);
          transaction.update(userFavoritesRef, {
            'FavoriteLocationIds': favoriteLocationIds,
          });
        }
      }
    });
  }
}
