import 'package:around_museo_de_baler_mobile_app/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/widgets/loaders/animation_loader.dart';
import '../constants/colors.dart';

class FullScreenLoader {

  /// Open a full-screen loading dialog with a given text and animation
  static void openLoadingDialog(String text, String animation) {
    showDialog(
        context: Get.overlayContext!,
        barrierDismissible: false,
        builder: (_) => WillPopScope(
          onWillPop: () async {
            // Handle the back button press as needed
            // Return false to prevent the user from closing the dialog
            return false;
          },
          child: Container(
            color: MAppHelperFunctions.isDarkMode(Get.context!) ? MAppColors.dark : MAppColors.white,
            width: double.infinity,
            height: double.infinity,
            child: Column(
              children: [
                const SizedBox(height: 250),
                AnimationLoaderWidget(text: text, animation: animation),
              ],
            ),
          ),
        ),
    );
  }

  /// Stop the currently open loading dialog
  static stopLoading() {
    Navigator.of(Get.overlayContext!).pop();
  }
}