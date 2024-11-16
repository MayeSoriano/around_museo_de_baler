import 'package:flutter/material.dart';

import '../../../../../utils/constants/sizes.dart';

class LocationAboutInfo extends StatelessWidget {
  const LocationAboutInfo({
    super.key,
    required this.leftIcon,
    this.rightIcon,
    required this.onTap,
    required this.value,
  });

  final IconData leftIcon;
  final IconData? rightIcon;
  final VoidCallback onTap;
  final String value;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: MAppSizes.spaceBtwItems / 1.5),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Icon(leftIcon, size: 18),
            ),
            const SizedBox(width: MAppSizes.spaceBtwItems / 2),
            Expanded(
              flex: 4,
              child: Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(
              child: Icon(rightIcon, size: 18),
            ),
          ],
        ),
      ),
    );
  }
}