import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../utils/formatters/formatter.dart';

class MuseumLogbookModel {
  String id;
  String userId;
  String firstName;
  String lastName;
  String addressCity;
  String addressProvState;
  String addressCountry;
  String gender;
  String birthYear;
  DateTime? timeIn;
  DateTime? timeOut;

  MuseumLogbookModel({
    required this.id,
    this.userId = '',
    required this.firstName,
    required this.lastName,
    required this.addressCity,
    required this.addressProvState,
    required this.addressCountry,
    this.gender = '',
    this.birthYear = '',
    this.timeIn,
    this.timeOut,
  });

  /// Helper function to get the full name
  String get fullName => '$firstName $lastName';

  /// Helper function to get the complete address
  String get completeAddress => '$addressCity, $addressProvState, $addressCountry';

  String get formattedTimeIn => MAppFormatter.formatDate(timeIn);
  String get formattedTimeOut => MAppFormatter.formatDate(timeOut);

  /// Helper function to convert the birth year to an int
  int get birthYearToInt {
    try {
      return int.parse(birthYear);
    } catch (e) {
      return 0;
    }
  }

  /// Static function to generate a username from the full name
  static String generateUsername(fullName) {
    List<String> nameParts = fullName.split(" ");
    String firstName = nameParts[0].toLowerCase();
    String lastName = nameParts.length > 1 ? nameParts[1].toLowerCase() : "";

    String camelCaseUsername = "$firstName$lastName";
    String usernameWithPrefix = "cwt_$camelCaseUsername";
    return usernameWithPrefix;
  }

  static MuseumLogbookModel empty() => MuseumLogbookModel(
    id: '',
    userId: '',
    firstName: '',
    lastName: '',
    gender: '',
    birthYear: '',
    addressCity: '',
    addressProvState: '',
    addressCountry: '',
    timeIn: DateTime.now(),
    timeOut: DateTime.now(),
  );

  /// Convert model to JSON structure for storing data in Firebase
  Map<String, dynamic> toJson() {
    return {
      'UserId': userId,
      'FirstName': firstName,
      'LastName': lastName,
      'Gender': gender,
      'BirthYear': birthYear,
      'AddressCity': addressCity,
      'AddressProvState': addressProvState,
      'AddressCountry': addressCountry,
      'TimeIn': timeIn,
      'TimeOut': timeOut,
    };
  }

  //Future<void> populateFullName() async {
  //  final userController = UserController.instance;
  // final user = userController.users.firstWhere((user) => user.id == userId, orElse: () => UserModel.empty());
  //  fullName = user.fullName;
  //}

  /// Factory method to create UserModel from a Firebase document snapshot
  factory MuseumLogbookModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return MuseumLogbookModel(
        id: document.id,
        userId: data['UserId'] ?? '',
        firstName: data['FirstName'] ?? '',
        lastName: data['LastName'] ?? '',
        gender: data['Gender'] ?? '',
        birthYear: data['BirthYear'] ?? '',
        addressCity: data['AddressCity'] ?? '',
        addressProvState: data['AddressProvState'] ?? '',
        addressCountry: data['AddressCountry'] ?? '',
        timeIn: data.containsKey('TimeIn') ? data['TimeIn']?.toDate() ?? DateTime.now() : DateTime.now(),
        timeOut: data.containsKey('TimeOut') ? data['TimeOut']?.toDate() ?? DateTime.now() : DateTime.now(),
      );
    } else {
      return MuseumLogbookModel.empty();
    }
  }
}
