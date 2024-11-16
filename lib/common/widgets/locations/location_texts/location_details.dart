import 'package:flutter/material.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../texts/location_title_text.dart';

class LocationDetails extends StatelessWidget {
  const LocationDetails({
    super.key,
    required this.title,
    required this.address,
  });

  final String title, address;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: MAppSizes.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LocationTitleText(
            title: title,
            smallSize: false,
            maxLines: 1,
          ),
          const SizedBox(height: MAppSizes.spaceBtwItems / 2),
          Row(
            children: [
              const Icon(Icons.location_pin,
                  color: MAppColors.secondary, size: MAppSizes.iconXs),
              const SizedBox(width: MAppSizes.xs),
              Expanded(
                child: Text(
                  address,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: MAppSizes.spaceBtwItems / 2),
        ],
      ),
    );
  }
}

