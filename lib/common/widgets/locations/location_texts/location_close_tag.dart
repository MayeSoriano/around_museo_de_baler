import 'package:flutter/material.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../custom_shapes/containers/rounded_container.dart';

class CloseTag extends StatelessWidget {
  const CloseTag({
    super.key,
    required this.opensAt,
  });

  final String opensAt;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 18,
      left: 12,
      child: RoundedContainer(
        radius: MAppSizes.sm,
        backgroundColor: MAppColors.darkerGrey.withOpacity(0.8),
        padding: const EdgeInsets.symmetric(
            horizontal: MAppSizes.sm, vertical: MAppSizes.xs),
        child: Text(
          opensAt,
          style: Theme.of(context)
              .textTheme
              .labelLarge!
              .apply(color: MAppColors.white),
        ),
      ),
    );
  }
}
