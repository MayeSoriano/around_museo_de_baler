import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart' as lot;
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/image_strings.dart';
import '../../../utils/device/device_utility.dart';
import '../../../utils/helpers/helper_functions.dart';
import '../../main/controllers/location_controller.dart';
import '../../main/models/location_model.dart';
import '../controllers/map_controller.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    super.key,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late final MapController _mapController;
  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();
  final locationInfoController = LocationController.instance;

  MapType _currentMapType = MapType.normal;
  LatLng? currentPosition;
  Set<Marker> _markers = {};

  Map<PolylineId, Polyline> polylines = {};
  LatLng originLocation = const LatLng(15.760205460734358, 121.56169660132952);
  LatLng destinationLocation =
      const LatLng(15.759078879821478, 121.56229880906874);

  final bool _isFollowingUserLocation =
      false; // Track if the camera should follow user location
  bool _isUserInteracting = false; // Track if the user is moving the camera
  bool _isMounted = false;

  final TextEditingController _searchController = TextEditingController();
  List<LocationModel> _foundLocations = [];
  bool _isSearching = false;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _isMounted = true;
    _loadMapStyles();
    _mapController = MapController(_customInfoWindowController);
    _loadMarkers().then((_) {}).catchError((error) {
      // Handle errors if necessary
      if (kDebugMode) {
        print('Error loading markers: $error');
      }
    });
    _getLocationUpdates();
    _moveCameraToMarker();
  }

  @override
  void dispose() {
    _isMounted = false;
    _mapController.dispose();
    _customInfoWindowController
        .dispose(); // Dispose of the map controller if it has a dispose method
    super.dispose();
  }

  void _loadMapStyles() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final isDarkMode = MAppHelperFunctions.isDarkMode(context);
      _mapController.loadMapStyle(isDarkMode);
    });
  }

  Future<void> _loadMarkers() async {
    Set<Marker> markers = await _mapController.loadMarkersFromLocations();
    _markers = markers; // Update the markers set with the newly loaded markers

    if (kDebugMode) {
      print('Markers loaded: $_markers'); // Check if markers are loaded
    }

    // Call setState to update the UI after loading markers
    setState(() {});
  }

  void _getLocationUpdates() {
    _mapController.getLocationUpdates((newPosition) {
      if (_isMounted) {
        // Update the current position
        setState(() {
          currentPosition = newPosition;
        });
        // Only move the camera if following user location is enabled and user isn't interacting
        if (_isFollowingUserLocation && !_isUserInteracting) {
          _mapController.moveCameraToPosition(newPosition);
        }
      }
    });
  }

  void _moveCameraToMarker() {
    if (MapController.selectedLocation != null) {
      // Move the camera to the selected location
      _mapController.moveCameraToMarker(MapController.selectedLocation);

      // After moving the camera, you can reset selectedLocation if necessary
      MapController.selectedLocation = null; // Reset the selected location
    }
  }

  void _runFilter(String enteredKeyword) {
    setState(() {
      searchQuery = enteredKeyword; // Update the search query
      _isSearching = enteredKeyword
          .isNotEmpty; // Set _isSearching based on input // Update the search query
    });

    List<LocationModel> results = [];

    if (enteredKeyword.isEmpty) {
      results =
          locationInfoController.allLocations; // Get all locations if no query
    } else {
      results = locationInfoController.allLocations
          .where((location) => location.name
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    setState(() {
      _foundLocations = results;
    });
  }

  void dismissKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus(); // Unfocus the current focus node
  }

  @override
  Widget build(BuildContext context) {
    final dark = MAppHelperFunctions.isDarkMode(context);
    final mapStyle = _currentMapType == MapType.satellite
        ? null // No custom style for satellite view
        : (dark ? _mapController.darkMapStyle : _mapController.lightMapStyle);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => _runFilter(value),
              decoration: InputDecoration(
                hintText: 'Search Location...',
                hintStyle: const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(
                    color: dark
                        ? Colors.white.withOpacity(0.4)
                        : Colors.black
                            .withOpacity(0.4), // Border color with opacity
                    width: 1.0, // Border width
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(
                    color: dark
                        ? Colors.white.withOpacity(0.4)
                        : Colors.black
                            .withOpacity(0.4), // Border color with opacity
                    width: 1.0, // Border width
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(
                    color: dark
                        ? Colors.white.withOpacity(0.8)
                        : Colors.black
                            .withOpacity(0.8), // Border color with opacity
                    width: 1.0, // Border width
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(
                    color: dark
                        ? Colors.white.withOpacity(0.4)
                        : Colors.black
                            .withOpacity(0.4), // Border color with opacity
                    width: 1.0, // Border width
                  ),
                ),
                filled: true,
                fillColor: dark ? MAppColors.dark : MAppColors.white,
                suffixIcon: const Icon(Icons.search, color: Colors.grey),
              ),
            ),
          ),
        ),
      ),
      body: locationInfoController.allLocations.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MAppHelperFunctions.screenWidth() * 0.15,
                    child: lot.Lottie.asset(MAppImages.arLoadingAnimation),
                  ),
                  Text(
                    "Loading...",
                    style: TextStyle(color: dark ? Colors.white : Colors.black),
                  ),
                ],
              ),
            )
          : Stack(
              children: [
                GoogleMap(
                  onMapCreated: (GoogleMapController controller) {
                    _mapController.mapController.complete(controller);
                    _customInfoWindowController.googleMapController =
                        controller;
                    setState(
                        () {}); // Ensure map updates properly after creation
                  },
                  initialCameraPosition: CameraPosition(
                    target: _mapController.initialLocation,
                    zoom: 13,
                  ),
                  markers: _markers,
                  polylines: Set<Polyline>.of(polylines.values),
                  zoomControlsEnabled: true,
                  trafficEnabled: true,
                  mapToolbarEnabled: true,
                  myLocationButtonEnabled: true,
                  myLocationEnabled: true,
                  compassEnabled: true,
                  mapType: _currentMapType,
                  padding: EdgeInsets.only(
                    top: MAppDeviceUtils.getAppBarHeight() * 2,
                  ),
                  style: mapStyle,
                  onCameraMoveStarted: () {
                    setState(() {
                      _isUserInteracting = true;
                    });
                  },
                  onCameraIdle: () {
                    setState(() {
                      _isUserInteracting = false;
                    });
                  },
                  onTap: (LatLng latLng) {
                    _customInfoWindowController
                        .hideInfoWindow!(); // Hide info window on map tap
                  },
                  onCameraMove: (CameraPosition position) {
                    _customInfoWindowController
                        .onCameraMove!(); // Move the custom window
                    _customInfoWindowController
                        .hideInfoWindow!(); // Hide info window on camera move
                    _isSearching = false;
                    dismissKeyboard(context);
                  },
                ),
                CustomInfoWindow(
                  controller: _customInfoWindowController,
                  height: 290,
                  width: 280,
                  offset: 50,
                ),
                Positioned(
                  top: MAppDeviceUtils.getAppBarHeight() * 3,
                  right: 12,
                  child: Material(
                    elevation: 2,
                    color: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            // Toggle the map type
                            _currentMapType = _currentMapType == MapType.normal
                                ? MapType.satellite
                                : MapType.normal;
                          });
                        },
                        icon: const Icon(
                          Icons.map,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: MAppDeviceUtils.getAppBarHeight() * 1.70,
                  right: 15,
                  left: 15,
                  child: _isSearching // Check if searching
                      ? (_foundLocations.isEmpty // Check if locations are found
                          ? const SizedBox
                              .shrink() // Don't display anything if no location found
                          : Container(
                              decoration: BoxDecoration(
                                color:
                                    dark ? MAppColors.dark : MAppColors.light,
                                borderRadius: BorderRadius.circular(8),
                                // Optional: Add rounded corners
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black
                                        .withOpacity(0.1), // Shadow color
                                    spreadRadius: 1, // Spread radius
                                    blurRadius: 5, // Blur radius
                                    offset: const Offset(0,
                                        3), // Changes the position of the shadow
                                  ),
                                ],
                              ),
                              child: ListView.builder(
                                padding: const EdgeInsets.all(15),
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _foundLocations.length > 5
                                    ? 5
                                    : _foundLocations.length,
                                // Limit to 5
                                itemBuilder: (context, index) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          MapController.selectedLocation =
                                              LatLng(
                                            _foundLocations[index]
                                                .coordinates
                                                .latitude,
                                            _foundLocations[index]
                                                .coordinates
                                                .longitude,
                                          );
                                          _moveCameraToMarker();
                                          setState(() {
                                            _isSearching =
                                                false; // Set _isSearching to false when a location is selected
                                          });
                                          _searchController.text =
                                              _foundLocations[index].name;
                                          dismissKeyboard(
                                              context); // Dismiss keyboard after selection
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5),
                                          child: Text(
                                            _foundLocations[index].name,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                          ),
                                        ),
                                      ),
                                      // Add a separator only if this is not the last item
                                      if (index <
                                          (_foundLocations.length > 5
                                              ? 4
                                              : _foundLocations.length - 1))
                                        const Divider(),
                                      // Separator line
                                    ],
                                  );
                                },
                              ),
                            ))
                      : const SizedBox
                          .shrink(), // Don't display anything if not searching
                ),
              ],
            ),
    );
  }
}
