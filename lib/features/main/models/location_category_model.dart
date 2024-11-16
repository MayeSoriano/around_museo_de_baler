import 'package:cloud_firestore/cloud_firestore.dart';

class LocationCategoryModel {
  String id;
  String name;
  String parentId;

  LocationCategoryModel({
    required this.id,
    required this.name,
    this.parentId = '',
  });

  /// Empty Helper Function
  static LocationCategoryModel empty() =>
      LocationCategoryModel(id: '', name: '');

  /// Convert Model to Json structure that you can store data in Firebase
  Map<String, dynamic> toJson() {
    return {
      'Name': name,
      'ParentId': parentId,
    };
  }

  /// Map Json oriented document snapshot from Firebase to LocationCategoryModel
  factory LocationCategoryModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return LocationCategoryModel(
      id: data['CategoryId'] as String,
      name: data['Name'] as String,
    );
  }
}
