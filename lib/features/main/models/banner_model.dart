import 'package:cloud_firestore/cloud_firestore.dart';

class BannerModel {
  String imageUrl;
  String title;
  String subtitle;

  final bool active;

  BannerModel({
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.active,
  });

  Map<String, dynamic> toJson() {
    return {
      'ImageUrl': imageUrl,
      'Title': title,
      'Subtitle': subtitle,
      'Active': active,
    };
  }

  factory BannerModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>>snapshot) {
      final data = snapshot.data() as Map<String, dynamic>;
      return BannerModel(
        imageUrl: data['ImageUrl'] ?? '',
        title: data['Title'] ?? '',
        subtitle: data['Subtitle'] ?? '',
        active:  data['Active'] ?? false,
      );
  }
}