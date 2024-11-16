import 'package:cloud_firestore/cloud_firestore.dart';

class UserFavoritesLocationModel {
  String userId;
  List<String> favoriteLocationIds;

  UserFavoritesLocationModel({
    required this.userId,
    required this.favoriteLocationIds,
  });

  /// Empty
  static UserFavoritesLocationModel empty() =>
      UserFavoritesLocationModel(
        userId: '',
        favoriteLocationIds: [],
      );

  /// JSON Format (for saving to Firestore)
  Map<String, dynamic> toJson() {
    return {
      'UserId': userId,
      'FavoriteLocationIds': favoriteLocationIds.isNotEmpty
          ? favoriteLocationIds
          : [],
    };
  }

  /// Map JSON oriented document snapshot from Firestore to Model
  factory UserFavoritesLocationModel.fromQuerySnapshot(
      QueryDocumentSnapshot<Object?> document) {
    final data = document.data() as Map<String, dynamic>;
    return UserFavoritesLocationModel(
      userId: document.id,
      favoriteLocationIds: data['FavoriteLocationIds'] != null
          ? List<String>.from(data['FavoriteLocationIds'])
          : [],
    );
  }

  /// Map JSON oriented document snapshot from Firestore to Model (for `DocumentSnapshot`)
  factory UserFavoritesLocationModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return UserFavoritesLocationModel(
      userId: document.id,
      favoriteLocationIds: data['FavoriteLocationIds'] != null
          ? List<String>.from(data['FavoriteLocationIds'])
          : [],
    );
  }
}
