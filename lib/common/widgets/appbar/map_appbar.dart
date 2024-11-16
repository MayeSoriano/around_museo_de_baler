import 'package:flutter/material.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/helpers/helper_functions.dart';

class MapsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MapsAppBar({
    super.key,
    this.actions,
    this.searchText,
    this.onSearchTextChanged,
  });

  final List<Widget>? actions;
  final String? searchText;
  final ValueChanged<String>? onSearchTextChanged;

  @override
  Widget build(BuildContext context) {
    final dark = MAppHelperFunctions.isDarkMode(context);

    return AppBar(
      backgroundColor: Colors.transparent,

      elevation: 5,
      title: Container(
        decoration: BoxDecoration(
          color: dark ? Colors.black : Colors.white,
          border: Border.all(color: Colors.transparent),
          borderRadius: BorderRadius.circular(200),
        ),
        child: TextField(
          cursorColor: MAppColors.primary,
          onChanged: onSearchTextChanged,

          decoration: InputDecoration(
            hintText: 'Search Location...',
            hintStyle: const TextStyle(color: MAppColors.darkGrey),
            border: const OutlineInputBorder(borderSide: BorderSide.none),
            prefixIcon: const Icon(Icons.search, color: Colors.grey),
            suffixIcon: searchText != null && searchText!.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () => onSearchTextChanged!(""),
              color: Colors.red,
                  )
                : null,
          ),
          style: TextStyle(color: dark ? MAppColors.light : MAppColors.dark),
        ),
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
