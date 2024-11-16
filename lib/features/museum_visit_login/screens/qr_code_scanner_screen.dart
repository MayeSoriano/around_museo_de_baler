import 'package:around_museo_de_baler_mobile_app/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_scanner_overlay/qr_scanner_overlay.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/helpers/helper_functions.dart';
import '../../museum_visit_login/controllers/qr_code_controller.dart';

class QRCodeScannerScreen extends StatefulWidget {
  const QRCodeScannerScreen({super.key});

  @override
  _QRCodeScannerScreenState createState() => _QRCodeScannerScreenState();
}

class _QRCodeScannerScreenState extends State<QRCodeScannerScreen> {
  late MobileScannerController cameraController;
  final controller = Get.put(QRCodeController());

  @override
  void initState() {
    super.initState();
    cameraController = MobileScannerController();
  }

  @override
  void dispose() {
    cameraController.dispose(); // Dispose of the camera controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dark = MAppHelperFunctions.isDarkMode(context);

    return Scaffold(
      backgroundColor: dark ? MAppColors.dark : MAppColors.light,
      appBar: AppBar(
        backgroundColor: dark ? MAppColors.dark : MAppColors.light,
        iconTheme:
            IconThemeData(color: dark ? MAppColors.white : MAppColors.black),
        actions: [
          // Flash Toggle Button
          Obx(() => IconButton(
                icon: Icon(
                  controller.isFlashOn.value ? Icons.flash_on : Icons.flash_off,
                  color: controller.isFrontCamera.value
                      ? Colors.grey // Gray out when the front camera is active
                      : controller.isFlashOn.value
                          ? (dark ? Colors.yellow : Colors.yellow.shade800)
                          : (dark ? MAppColors.white : MAppColors.black),
                ),
                onPressed: controller.isFrontCamera.value
                    ? null // Disable the button if the front camera is active
                    : () => controller.toggleFlash(cameraController),
              )),
          // Camera Switch Button
          IconButton(
            icon: Icon(Icons.cameraswitch,
                color: dark ? MAppColors.white : MAppColors.black),
            onPressed: () => controller.switchCamera(cameraController),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(MAppSizes.md),
        child: Column(
          children: [
            /// Instruction Text
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Align the QR Code within the frame",
                    style: TextStyle(
                      color: dark ? MAppColors.white : MAppColors.black,
                      fontSize: MAppSizes.fontSizeLg,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Ensure the entire QR code fits within the area.",
                    style: TextStyle(
                      color: dark ? MAppColors.light : MAppColors.dark,
                      fontSize: MAppSizes.fontSizeMd,
                    ),
                  ),
                ],
              ),
            ),

            /// QR Scanner
            Expanded(
              flex: 4,
              child: Stack(
                children: [
                  MobileScanner(
                    controller: cameraController,
                    onDetect: (barcodeCapture) {
                      // Ensure scanning happens only if scan is not completed yet
                      if (!controller.scanCompleted.value) {
                        if (barcodeCapture.barcodes.isNotEmpty) {
                          final String scannedCode =
                              barcodeCapture.barcodes.first.rawValue ?? '';

                          // Check the scanned code
                          if (scannedCode.isNotEmpty) {
                            controller.checkQRCode(
                                scannedCode); // Call the QR code check function
                          }
                        }
                      }
                    },
                  ),
                  QRScannerOverlay(
                    overlayColor: dark ? MAppColors.dark : MAppColors.light,
                    borderColor: MAppColors.primary,
                  ),
                ],
              ),
            ),

            /// Info Text
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  "This scan will register your museum visit.",
                  style: TextStyle(
                    color: dark ? MAppColors.light : MAppColors.dark,
                    fontSize: MAppSizes.fontSizeMd,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
