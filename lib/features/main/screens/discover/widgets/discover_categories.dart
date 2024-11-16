import 'package:flutter/material.dart';

import '../../../../../common/widgets/image_text_widgets/vertical_image_text.dart';
import '../../../../../utils/constants/image_strings.dart';
import '../../../../../utils/helpers/helper_functions.dart';

class DiscoverCategories extends StatelessWidget {
  const DiscoverCategories({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      width: MAppHelperFunctions.screenWidth() * 0.9,
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: 4,
          scrollDirection: Axis.horizontal,
          itemBuilder: (_, index) {
            return VerticalImageText(image: MAppImages.touristSpotIcon, title: 'Tourist Spot', onTap: (){},);
          }
      ),
    );
  }
}