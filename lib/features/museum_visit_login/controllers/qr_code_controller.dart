import 'package:around_museo_de_baler_mobile_app/data/repositories/qr_code/qr_code_repository.dart';
import 'package:around_museo_de_baler_mobile_app/features/augmented_reality/screens/ar_content_camera_screen.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../data/repositories/museum_logbook/museum_logbook_repository.dart';
import '../../../utils/popups/loaders.dart';
import '../../personalization/controllers/user_controller.dart';
import '../models/museum_logbook_model.dart';

class QRCodeController extends GetxController {
  final repository = Get.put(QRCodeRepository());
  final museumLogbookRepository = Get.put(MuseumLogbookRepository());

  // Observable state for QR code and access result
  Rxn<String> scannedCode = Rxn<String>();
  Rx<bool> scanCompleted = false.obs;
  RxBool isFlashOn = false.obs;
  RxBool isFrontCamera = false.obs;
  Rx<String> documentId = ''.obs;

  /// Check the current QR Code
  Future<void> checkQRCode(String scannedCode) async {
    try {
      scanCompleted.value = true;
      final currentQRCode = await repository.getCurrentQRCode();

      if (currentQRCode == scannedCode) {
        // Handle successful match (e.g., navigate to AR content)
        Get.snackbar('Success', 'QR code matched! Access granted.');
        // Save user museum visit
        await logMuseumVisit();
        // Redirect to a new screen after successful scan
        Get.off(() =>
            const ArContentCameraScreen()); // Replace with your actual screen
      } else {
        Get.snackbar('Access Denied', 'QR code does not match.');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to check QR code: $e');
    }
  }

  Future<void> logMuseumVisit() async {
    try {
      // Retrieve user data first
      final userController = UserController.instance;
      await userController.fetchUserRecord(); // Fetch user data
      final user = userController.user;

      // Create a MuseumLogbookModel instance
      final museumLogbook = MuseumLogbookModel(
        id: '',
        // Firestore will generate the ID
        userId: user.value.id,
        firstName: user.value.firstName,
        lastName: user.value.lastName,
        addressCity: user.value.addressCity,
        addressProvState: user.value.addressProvState,
        addressCountry: user.value.addressCountry,
        gender: user.value.gender,
        birthYear: user.value.birthYear,
        timeIn: DateTime.now(),
        // Set timeIn to current time
        timeOut: null, // TimeOut can be updated later
      );

      // Save the visit log to Firestore and retrieve the document ID
      String museumLogRef =
          await museumLogbookRepository.addMuseumVisitLog(museumLogbook);
      documentId.value = museumLogRef;
      print("Document ID: ${documentId.value}");

      // Save the visit log to Firestore
      //await museumLogbookRepository.addMuseumVisitLog(museumLogbook);
    } catch (e) {
      // Handle errors
      MAppLoaders.warningSnackBar(
        title: 'Oh Snap!',
        message: e.toString(),
      );
    }
  }

  /// Update the logbook time-out based on document id
  Future<void> updateMuseumVisitTimeOut() async {
    try {
      final timeOut = DateTime.now();
      await museumLogbookRepository.updateTimeOut(documentId.value, timeOut);
      print("Time-out updated for Document ID: ${documentId.value}");
    } catch (e) {
      MAppLoaders.warningSnackBar(
        title: 'Update Failed',
        message: e.toString(),
      );
    }
  }

  Future<void> toggleFlash(MobileScannerController cameraController) async {
    try {
      await cameraController.toggleTorch(); // Await the torch toggle completion
      isFlashOn.value = !isFlashOn.value;   // Update flash state only after successful toggle
    } catch (e) {
      print("Error toggling flash: $e");     // Handle any errors
    }
  }

  Future<void> switchCamera(MobileScannerController cameraController) async {
    try {
      await cameraController.switchCamera(); // Switch the camera
      isFlashOn.value = false; // Turn off flash if it's on
      isFrontCamera.value = !isFrontCamera.value;
    } catch (e) {
      print("Error switching camera: $e");
    }
  }

  /// Reset the scan status (this can be used if the user wants to scan again)
  void resetScan() {
    scanCompleted.value = false;
    scannedCode.value = null;
  }
}
