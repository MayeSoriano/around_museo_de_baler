import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../utils/constants/enums.dart';

/// Model class representing user data
class UserModel {
  final String id;
  String firstName;
  String lastName;
  String email;
  String gender;
  String birthYear;
  String addressCity;
  String addressProvState;
  String addressCountry;
  String profilePicture;
  AppRole role;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? lastActive;

  /// Constructor for UserModel
  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.gender = '',
    this.birthYear = '',
    required this.addressCity,
    required this.addressProvState,
    required this.addressCountry,
    this.profilePicture = '',
    this.role = AppRole.user,
    this.createdAt,
    this.updatedAt,
    this.lastActive,
  });

  /// Helper function to get the full name
  String get fullName => '$firstName $lastName';

  /// Helper function to get the complete address
  String get completeAddress => '$addressCity, $addressProvState, $addressCountry';

  /// Static function to split full name into first and last name
  static List<String> nameParts(fullName) => fullName.split(" ");

  /// Static function to generate a username from the full name
  static String generateUsername(fullName) {
    List<String> nameParts = fullName.split(" ");
    String firstName = nameParts[0].toLowerCase();
    String lastName = nameParts.length > 1 ? nameParts[1].toLowerCase() : "";

    String camelCaseUsername = "$firstName$lastName";
    String usernameWithPrefix = "cwt_$camelCaseUsername";
    return usernameWithPrefix;
  }

  /// Static function to create an empty user model
  static UserModel empty() => UserModel(
    id: '',
    firstName: '',
    lastName: '',
    email: '',
    addressCity: '',
    addressProvState: '',
    addressCountry: '',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    lastActive: DateTime.now(),
  );

  /// Convert model to JSON structure for storing data in Firebase
  Map<String, dynamic> toJson() {
    return {
      'FirstName': firstName,
      'LastName': lastName,
      'Email': email,
      'Gender': gender,
      'BirthYear': birthYear,
      'AddressCity': addressCity,
      'AddressProvState': addressProvState,
      'AddressCountry': addressCountry,
      'ProfilePicture': profilePicture,
      'Role': role.name.toString(),
      'CreatedAt': createdAt = DateTime.now(),
      'UpdatedAt': updatedAt = DateTime.now(),
      'LastActive': lastActive = DateTime.now(),
    };
  }

  /// Factory method to create UserModel from a Firebase document snapshot
  factory UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return UserModel(
        id: document.id,
        firstName: data['FirstName'] ?? '',
        lastName: data['LastName'] ?? '',
        email: data['Email'] ?? '',
        gender: data['Gender'] ?? '',
        birthYear: data['BirthYear'] ?? '',
        addressCity: data['AddressCity'] ?? '',
        addressProvState: data['AddressProvState'] ?? '',
        addressCountry: data['AddressCountry'] ?? '',
        profilePicture: data['ProfilePicture'] ?? '',
        role: data.containsKey('Role') ? (data['Role'] ?? AppRole.user) == AppRole.admin.name.toString() ? AppRole.admin : AppRole.user: AppRole.user,
        createdAt: data.containsKey('CreatedAt') ? data['CreatedAt']?.toDate() ?? DateTime.now() : DateTime.now(),
        updatedAt: data.containsKey('UpdatedAt') ? data['UpdatedAt']?.toDate() ?? DateTime.now() : DateTime.now(),
        lastActive: data.containsKey('lastActive') ? data['lastActive']?.toDate() ?? DateTime.now() : DateTime.now(),
      );
    } else {
      return UserModel.empty();
    }
  }
}
