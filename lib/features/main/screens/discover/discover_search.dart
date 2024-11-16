import 'package:flutter/material.dart';

import '../../../../common/widgets/locations/location_cards/location_card.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../../controllers/location_controller.dart';
import '../../models/location_model.dart';

class DiscoverSearch extends StatefulWidget {
  const DiscoverSearch({super.key});

  @override
  State<DiscoverSearch> createState() => _DiscoverSearchState();
}

class _DiscoverSearchState extends State<DiscoverSearch> {
  final LocationController locationController = LocationController.instance;

  List<LocationModel> _foundLocations = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
  }

  void _runFilter(String enteredKeyword) {
    List<LocationModel> results = [];

    if (enteredKeyword.isEmpty) {
      results = locationController.allLocations;
    } else {
      results = locationController.allLocations
          .where((location) => location.name
          .toLowerCase()
          .contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    setState(() {
      _foundLocations = results;
      _isSearching = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final dark = MAppHelperFunctions.isDarkMode(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 70,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: dark ? MAppColors.white : MAppColors.black),
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: dark ? Colors.white : Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        title: Container(
          decoration: BoxDecoration(
            color: dark ? MAppColors.dark : MAppColors.white,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: TextField(
              autofocus: true,
              onChanged: (value) => _runFilter(value),
              decoration: InputDecoration(
                  hintText: 'Search Location...',
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(
                      color: dark
                          ? Colors.white.withOpacity(0.4)
                          : Colors.black.withOpacity(0.4),
                      width: 1.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(
                      color: dark
                          ? Colors.white.withOpacity(0.4)
                          : Colors.black.withOpacity(0.4),
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(
                      color: dark
                          ? Colors.white.withOpacity(0.8)
                          : Colors.black.withOpacity(0.8),
                      width: 1.0,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(
                      color: dark
                          ? Colors.white.withOpacity(0.4)
                          : Colors.black.withOpacity(0.4),
                      width: 1.0,
                    ),
                  ),
                  filled: true,
                  fillColor: dark ? MAppColors.dark : MAppColors.white,
                  suffixIcon: const Icon(Icons.search, color: Colors.grey)),
            ),
          ),
        ),
      ),
      body: !_isSearching
          ? Container() // No search yet, show nothing
          : _foundLocations.isNotEmpty
          ? Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: _foundLocations.length,
          itemBuilder: (_, index) {
            return Padding(
              padding: const EdgeInsets.only(top: MAppSizes.md),
              child: LocationCard(
                height: 170,
                width: double.infinity,
                location: _foundLocations[index],
              ),
            );
          },
        ),
      )
          : const Center(
        child: Text(
          'No Location Found.',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
        ),
      ),
    );
  }
}