import 'package:around_museo_de_baler_mobile_app/common/widgets/locations/location_texts/location_category_title_text.dart';
import 'package:flutter/material.dart';

import '../../../../utils/constants/enums.dart';

class LocationCategoryTitle extends StatelessWidget {
  const LocationCategoryTitle({
    super.key,
    required this.title,
    this.maxLines = 1,
    this.textColor,
    this.textAlign = TextAlign.center,
    this.categoryTextSize = TextSizes.small,
  });

  final String title;
  final int maxLines;
  final Color? textColor;
  final TextAlign textAlign;
  final TextSizes categoryTextSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: LocationCategoryTitleText(
            title: title,
            maxLines: maxLines,
            textAlign: textAlign,
            categoryTextSize: categoryTextSize,
          ),
        ),
      ],
    );
  }
}
