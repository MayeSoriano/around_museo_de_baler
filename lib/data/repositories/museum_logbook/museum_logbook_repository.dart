import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../features/museum_visit_login/models/museum_logbook_model.dart';
import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';

class MuseumLogbookRepository extends GetxController {
  // Singleton instance of the MuseumLogbookRepository
  static MuseumLogbookRepository get instance => Get.find();

  // Firebase Firestore instance
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /* ---------------------------- FUNCTIONS ---------------------------------*/
  // Save museum visit log of user
  Future<String> addMuseumVisitLog(MuseumLogbookModel log) async {
    try {
      // Add the log to Firestore and get the document reference
      final docRef = await _db.collection('Museum_Logbook').add(log.toJson());
      return docRef.id; // Return the document ID
    } on FirebaseException catch (e) {
      throw MAppFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const MAppFormatException();
    } on PlatformException catch (e) {
      throw MAppPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  // Update the timeOut field for a specific museum visit log
  Future<void> updateTimeOut(String documentId, DateTime timeOut) async {
    try {
      await _db.collection('Museum_Logbook').doc(documentId).update({
        'timeOut': timeOut,
      });
    } on FirebaseException catch (e) {
      throw MAppFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw MAppPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong while updating time-out. Please try again';
    }
  }

}