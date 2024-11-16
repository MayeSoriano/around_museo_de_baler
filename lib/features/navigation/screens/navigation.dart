import 'dart:async';
import 'dart:convert';

import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart' as lot;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../common/widgets/loaders/shimmer_effect.dart';
import '../../../utils/constants/api_constants.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/image_strings.dart';
import '../../../utils/device/device_utility.dart';
import '../../../utils/helpers/helper_functions.dart';
import '../controllers/map_controller.dart';

class NavigationScreen extends StatefulWidget {
  final LatLng destination;
  final String locationName;

  const NavigationScreen({
    Key? key,
    required this.destination,
    required this.locationName,
  }) : super(key: key);

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  GoogleMapController? _googleMapController;
  late final MapController _mapController;
  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();
  final TextEditingController _originController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();

  final Set<Marker> _markers = {};
  Map<PolylineId, Polyline> polylines = {};

  MapType _currentMapType = MapType.normal;

  LatLng _origin = const LatLng(15.760205460734358, 121.56169660132952);
  String? _distance;
  String? _duration;
  LatLng? _currentPosition;

  StreamSubscription<Position>? _positionStreamSubscription;
  final bool _navigationStarted = false;

  @override
  void initState() {
    super.initState();
    _mapController = MapController(_customInfoWindowController);
    _loadMapStyles();
    _getUserCurrentLocation().then((_) {
      _getPolylinePoints();
      _fetchDistanceAndETA();
      _loadMarkers().then((_) {
        _animateCameraToFitMarkers(); // Call after markers are loaded
      });
    });
  }

  @override
  void dispose() {
    _mapController.dispose();
    _customInfoWindowController
        .dispose(); // Dispose of the map controller if it has a dispose method
    _originController.dispose();
    _destinationController.dispose();
    super.dispose();
  }

  void _loadMapStyles() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final isDarkMode = MAppHelperFunctions.isDarkMode(context);
      _mapController.loadMapStyle(isDarkMode);
    });
  }

  Future<void> _getUserCurrentLocation() async {
    try {
      // Request location permission
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        // Get current position
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        setState(() {
          _currentPosition = LatLng(position.latitude, position.longitude);
          // Set origin = current pos
          _origin = _currentPosition!;
          _originController.text =
              'Current Location'; // Optionally set the origin controller text
          _destinationController.text = widget.locationName;
          _loadMarkers(); // Reload markers to include current position
        });
      }
    } catch (e) {
      print("Error getting current location: $e");
    }
  }

  Future<void> _loadMarkers() async {
    setState(() {
      // Clear existing markers
      _markers.clear();

      // Add current position marker
      if (_currentPosition != null) {
        _markers.add(
          Marker(
            markerId: const MarkerId('origin'),
            position: _currentPosition!,
            infoWindow: const InfoWindow(
                title: 'Starting Location'), // Updated marker title
          ),
        );
      }

      // Add destination marker
      _markers.add(
        Marker(
          markerId: const MarkerId('destination'),
          position: widget.destination,
          infoWindow: InfoWindow(title: widget.locationName),
        ),
      );
    });
  }

  Future<void> _getPolylinePoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: APIConstants.mapAPIKey,
      request: PolylineRequest(
        origin: PointLatLng(_origin.latitude, _origin.longitude),
        destination: PointLatLng(
            widget.destination.latitude, widget.destination.longitude),
        mode: TravelMode.driving,
      ),
    );

    if (result.points.isNotEmpty) {
      List<LatLng> polylineCoordinates = [];
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
      _generatePolyLine(polylineCoordinates);
    } else {
      print(result.errorMessage);
    }
  }

  void _generatePolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: MAppColors.primary,
      points: polylineCoordinates,
      width: 5,
    );

    setState(() {
      polylines[id] = polyline; // Store polyline in the map
    });
  }

  Future<Map<String, dynamic>?> getDistanceAndETA({
    required LatLng origin,
    required LatLng destination,
  }) async {
    // Build the API request URL
    String url = 'https://maps.googleapis.com/maps/api/distancematrix/json'
        '?origins=${origin.latitude},${origin.longitude}'
        '&destinations=${destination.latitude},${destination.longitude}'
        '&key=AIzaSyDT7QfIQzyaAu_-xfUM5eXMvtocoJQlDSU'
        '&mode=driving'; // You can change mode to walking, bicycling, etc.

    try {
      // Make the HTTP request
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Parse the JSON response
        Map<String, dynamic> data = json.decode(response.body);

        if (data['rows'] != null && data['rows'].isNotEmpty) {
          // Extract distance and duration
          var element = data['rows'][0]['elements'][0];
          String distance = element['distance']['text']; // e.g., "5.2 km"
          String duration = element['duration']['text']; // e.g., "15 mins"

          return {
            'distance': distance,
            'duration': duration,
          };
        }
      }
    } catch (e) {
      print("Error fetching distance and ETA: $e");
    }
    return null;
  }

  Future<void> _fetchDistanceAndETA() async {
    final data = await getDistanceAndETA(
      origin: _origin,
      destination: widget.destination,
    );
    if (data != null) {
      setState(() {
        _distance = data['distance'];
        _duration = data['duration'];
      });
    }
  }

  void _openGoogleMaps() async {
    final String origin = '${_origin.latitude},${_origin.longitude}';
    final String destination =
        '${widget.destination.latitude},${widget.destination.longitude}';

    // Create the Uri object
    final Uri url = Uri.parse(
        'https://www.google.com/maps/dir/?api=1&origin=$origin&destination=$destination');

    // Use canLaunchUrl and launchUrl methods
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  // Method to calculate the bounds
  LatLngBounds _calculateBounds(LatLng origin, LatLng destination) {
    double southWestLat = origin.latitude < destination.latitude
        ? origin.latitude
        : destination.latitude;
    double southWestLng = origin.longitude < destination.longitude
        ? origin.longitude
        : destination.longitude;
    double northEastLat = origin.latitude > destination.latitude
        ? origin.latitude
        : destination.latitude;
    double northEastLng = origin.longitude > destination.longitude
        ? origin.longitude
        : destination.longitude;

    return LatLngBounds(
      southwest: LatLng(southWestLat, southWestLng),
      northeast: LatLng(northEastLat, northEastLng),
    );
  }

  Future<void> _animateCameraToFitMarkers() async {
    if (_currentPosition != null && _googleMapController != null) {
      LatLngBounds bounds = _calculateBounds(_origin, widget.destination);
      await _googleMapController!
          .animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
    }
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
        iconTheme: IconThemeData(color: dark ? Colors.white : Colors.black),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(75),
          child: Visibility(
            visible: true,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: MAppHelperFunctions.screenWidth(),
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  decoration: BoxDecoration(
                    color: dark ? MAppColors.dark : MAppColors.light,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("ORIGIN: Current Location",
                          overflow: TextOverflow.ellipsis),
                      const Divider(),
                      Text("DESTINATION: ${widget.locationName}",
                          overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              _mapController.mapController.complete(controller);
              _customInfoWindowController.googleMapController = controller;
              _googleMapController = controller;
              setState(() {}); // Ensure map updates properly after creation
            },
            initialCameraPosition: CameraPosition(
              target: _currentPosition ?? widget.destination,
              zoom: 14,
            ),
            markers: _markers,
            polylines: Set<Polyline>.of(polylines.values),
            zoomControlsEnabled: true,
            trafficEnabled: true,
            mapToolbarEnabled: false,
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            compassEnabled: true,
            mapType: _currentMapType,
            padding: EdgeInsets.only(
              top: MAppDeviceUtils.getAppBarHeight() * 2.9,
              bottom: MAppDeviceUtils.getAppBarHeight() * 1.7,
            ),
            style: mapStyle,
          ),
          // Distance and ETA display
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Material(
              elevation: 5,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
                decoration: BoxDecoration(
                  color: dark ? MAppColors.dark : MAppColors.light,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Conditional display for shimmer or actual data
                            _distance == null || _duration == null
                                ? const Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ShimmerEffect(width: 250, height: 25),
                                      SizedBox(height: 8),
                                      ShimmerEffect(width: 220, height: 20),
                                    ],
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            '$_duration',
                                            style: const TextStyle(
                                                fontSize: 20,
                                                color: MAppColors.accent),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            '($_distance)',
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: dark
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        'Fastest route, the usual traffic.',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: dark
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _openGoogleMaps();
                            // Start navigation
                            // Camera will follow user's position
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                          ),
                          child: const Row(
                            children: [
                              Text('Start'),
                              // Start or Exit Nav, dynamically change
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: MAppDeviceUtils.getAppBarHeight() * 3.9,
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
        ],
      ),
    );
  }
}
