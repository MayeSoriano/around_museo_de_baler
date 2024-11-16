import 'package:cloud_firestore/cloud_firestore.dart';

class LocationModel {
  String id;
  String name;
  String categoryId;
  String subCategoryId;
  String categoryName;
  String subCategoryName;
  String address;
  GeoPoint coordinates;
  String description;
  String contactNumber;
  String socials;
  String thumbnail;
  List<String>? images;
  Map<String, String>? operatingHours;
  bool isFeatured;
  bool isOpen;
  String openTimes;
  String closeTimes;

  LocationModel({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.subCategoryId,
    required this.categoryName,
    required this.subCategoryName,
    required this.address,
    required this.coordinates,
    required this.description,
    required this.contactNumber,
    required this.socials,
    required this.thumbnail,
    this.images,
    this.operatingHours,
    this.isFeatured = false,
    this.isOpen = false,
    this.openTimes = '',
    this.closeTimes = '',
  });

  /// Empty
  static LocationModel empty() =>
      LocationModel(
        id: '',
        name: '',
        categoryId: '',
        categoryName: '',
        subCategoryId: '',
        subCategoryName: '',
        address: '',
        coordinates: const GeoPoint(0, 0),
        description: '',
        contactNumber: '',
        socials: '',
        thumbnail: '',
      );

  /// Json Format
  toJson() {
    return {
      'Name': name,
      'CategoryId': categoryId,
      'SubCategoryId': subCategoryId,
      'CategoryName': categoryName,
      'SubCategoryName': subCategoryName,
      'Address': address,
      'Coordinates': {
        'latitude': coordinates.latitude,
        'longitude': coordinates.longitude
      },
      'Description': description,
      'ContactNumber': contactNumber,
      'Socials': socials,
      'Thumbnail': thumbnail,
      'Images': images != null ? images! : [],
      'OperatingHours': operatingHours != null ? operatingHours! : {},
      'IsFeatured': isFeatured,
    };
  }

  /// Map Json oriented document snapshot from Firebase to Model
  factory LocationModel.fromQuerySnapshot(
      QueryDocumentSnapshot<Object?> document) {
    final data = document.data() as Map<String, dynamic>;
    return LocationModel(
      id: document.id,
      name: data['Name'] ?? '',
      categoryId: data['CategoryId'] ?? '',
      subCategoryId: data['SubCategoryId'] ?? '',
      categoryName: data['CategoryName'] ?? '',
      subCategoryName: data['SubCategoryName'] ?? '',
      address: data['Address'] ?? '',
      coordinates: data['Coordinates'] ?? const GeoPoint(0, 0),
      description: data['Description'] ?? '',
      contactNumber: data['ContactNumber'] ?? '',
      socials: data['Socials'] ?? '',
      thumbnail: data['Thumbnail'] ?? '',
      images: data['Images'] != null ? List<String>.from(data['Images']) : [],
      operatingHours: data['OperatingHours'] != null ? Map<String, String>.from(
          data['OperatingHours']) : {},
      isFeatured: data['IsFeatured'] ?? false,
    );
  }

  /// Map Json oriented document snapshot from Firebase to Model
  factory LocationModel.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data();
    return LocationModel(
      id: document.id,
      name: data['Name'] ?? '',
      categoryId: data['CategoryId'] ?? '',
      subCategoryId: data['SubCategoryId'] ?? '',
      categoryName: data['CategoryName'] ?? '',
      subCategoryName: data['SubCategoryName'] ?? '',
      address: data['Address'] ?? '',
      coordinates: data['Coordinates'] ?? const GeoPoint(0, 0),
      description: data['Description'] ?? '',
      contactNumber: data['ContactNumber'] ?? '',
      socials: data['Socials'] ?? '',
      thumbnail: data['Thumbnail'] ?? '',
      images: data['Images'] != null ? List<String>.from(data['Images']) : [],
      operatingHours: data['OperatingHours'] != null ? Map<String, String>.from(
          data['OperatingHours']) : {},
      isFeatured: data['IsFeatured'] ?? false,
    );
  }
}
