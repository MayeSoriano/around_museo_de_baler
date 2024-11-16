import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class QRCodeRepository extends GetxController {
  static QRCodeRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  /// Retrieve the current QR code from the database
  Future<String?> getCurrentQRCode() async {
    DocumentSnapshot<Map<String, dynamic>> doc = await _db.collection('QR_Code').doc('currentQRCode').get();
    if (doc.exists) {
      return doc.data()?['Code'] as String?;
    }
    return null; // Handle case where the document does not exist
  }
}
