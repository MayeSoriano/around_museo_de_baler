import 'package:around_museo_de_baler_mobile_app/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

import '../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../common/widgets/locations/favorites/favorites_menu_icon.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/text_strings.dart';

class DiscoverAppBar extends StatelessWidget {
  const DiscoverAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dark = MAppHelperFunctions.isDarkMode(context);

    return MAppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            MAppTexts.discoverAppBarTitle,
            style: Theme.of(context).textTheme.labelMedium,
          ),
          Text(
            MAppTexts.discoverAppBarSubtitle,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ],
      ),
      actions: [
        FavoritesCounterIcon(onPressed: (){}, iconColor: dark ? MAppColors.white : MAppColors.dark),
      ],
    );
  }
}