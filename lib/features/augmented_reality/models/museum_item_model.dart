import 'package:cloud_firestore/cloud_firestore.dart';

class MuseumItemModel {
  String id;
  String title;
  String artist;
  String categoryId;
  String subCategoryId;
  String categoryName;
  String subCategoryName;
  String description;
  String year;
  String imageMarker;
  String modelFileName;

  MuseumItemModel({
    required this.id,
    required this.title,
    required this.artist,
    required this.categoryId,
    required this.subCategoryId,
    required this.categoryName,
    required this.subCategoryName,
    required this.description,
    required this.year,
    required this.imageMarker,
    required this.modelFileName,
  });

  /// Empty constructor
  static MuseumItemModel empty() => MuseumItemModel(
    id: '',
    title: '',
    artist: '',
    categoryId: '',
    subCategoryId: '',
    categoryName: '',
    subCategoryName: '',
    description: '',
    year: '',
    imageMarker: '',
    modelFileName: '',
  );

  /// Convert model to JSON format
  Map<String, dynamic> toJson() {
    return {
      'Title': title,
      'Artist': artist,
      'CategoryId': categoryId,
      'SubCategoryId': subCategoryId,
      'CategoryName': categoryName,
      'SubCategoryName': subCategoryName,
      'Description': description,
      'Year': year,
      'ImageMarker': imageMarker,
      'ModelFileName': modelFileName,
    };
  }

  /// Create model from Firestore query snapshot
  factory MuseumItemModel.fromQuerySnapshot(
      QueryDocumentSnapshot<Object?> document) {
    final data = document.data() as Map<String, dynamic>;
    return MuseumItemModel(
      id: document.id,
      title: data['Title'] ?? '',
      artist: data['Artist'] ?? '',
      categoryId: data['CategoryId'] ?? '',
      subCategoryId: data['SubCategoryId'] ?? '',
      categoryName: data['CategoryName'] ?? '',
      subCategoryName: data['SubCategoryName'] ?? '',
      description: data['Description'] ?? '',
      year: data['Year'] ?? '',
      imageMarker: data['ImageMarker'] ?? '',
      modelFileName: data['ModelFileName'] ?? '',
    );
  }

  /// Create model from Firestore snapshot
  factory MuseumItemModel.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data();
    return MuseumItemModel(
      id: document.id,
      title: data['Title'] ?? '',
      artist: data['Artist'] ?? '',
      categoryId: data['CategoryId'] ?? '',
      subCategoryId: data['SubCategoryId'] ?? '',
      categoryName: data['CategoryName'] ?? '',
      subCategoryName: data['SubCategoryName'] ?? '',
      description: data['Description'] ?? '',
      year: data['Year'] ?? '',
      imageMarker: data['ImageMarker'] ?? '',
      modelFileName: data['ModelFileName'] ?? '',
    );
  }
}
