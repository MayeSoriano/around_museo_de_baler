import 'package:around_museo_de_baler_mobile_app/utils/constants/sizes.dart';
import 'package:around_museo_de_baler_mobile_app/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

import '../constants/colors.dart';

class CustomAlertDialogV1 extends StatelessWidget {
  const CustomAlertDialogV1({
    super.key,
    required this.title,
    required this.content,
    required this.onConfirm,
  });

  final String title, content;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    final dark = MAppHelperFunctions.isDarkMode(context);

    return AlertDialog(
      backgroundColor: dark ? MAppColors.dark : MAppColors.white,
      title: Text(title),
      content: Text(content),
      actions: [
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: MAppSizes.defaultSpace / 2),
                  child: Text('Cancel'),
                ),
              ),
              const SizedBox(width: MAppSizes.spaceBtwItems),
              ElevatedButton(
                onPressed: onConfirm,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: MAppSizes.defaultSpace),
                  child: Text('Reset'),
                ),
              ),
            ],
          ),
        ),

      ],
    );
  }
}
