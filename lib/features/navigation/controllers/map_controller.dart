import 'dart:async';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';
import 'package:around_museo_de_baler_mobile_app/utils/constants/map_style.dart';

import '../../main/controllers/location_controller.dart';
import '../screens/widgets/custom_info_window.dart';

class MapController {
  final Completer<GoogleMapController> mapController = Completer();
  Location locationController = Location();
  final locationInfoController = LocationController.instance;

  final CustomInfoWindowController _customInfoWindowController;
  // Constructor that receives the CustomInfoWindowController from outside
  MapController(this._customInfoWindowController);

  LatLng? currentPosition;
  String darkMapStyle = "";
  String lightMapStyle = "";
  StreamSubscription<LocationData>?
      locationSubscription; // Subscription variable

  Set<Marker> markers = {};
  MarkerId? selectedMarkerId;

  LatLng initialLocation = const LatLng(15.759018066772345, 121.56654938336024);
  static LatLng? selectedLocation;

  // Load the map style based on the theme
  Future<void> loadMapStyle(bool isDarkMode) async {
    try {
      lightMapStyle =
          await rootBundle.loadString(MAppMapStyles.mapStyleLightMode);
      darkMapStyle =
          await rootBundle.loadString(MAppMapStyles.mapStyleDarkMode);
    } catch (e) {
      if (kDebugMode) {
        print("Error loading map styles: $e");
      }
    }
  }

  Future<Set<Marker>> loadMarkersFromLocations() async {
    for (var location in locationInfoController.touristSpots) {
      // Construct the asset path based on MarkerId (or name or another unique identifier)
      final String assetPath = 'assets/image_markers/${location.id}.png';

      if (kDebugMode) {
        print('Marker ID: ${location.id}, Asset Path: $assetPath');
      }

      // Load the bitmap icon from the asset for each location
      final BitmapDescriptor bitmapIcon = await BitmapDescriptor.asset(
        const ImageConfiguration(size: Size(48, 48)), // Set the size as needed
        assetPath, // Use the constructed asset path
      );

      markers.add(
        Marker(
          markerId: MarkerId(location.name),
          position: LatLng(
              location.coordinates.latitude, location.coordinates.longitude),
          icon: bitmapIcon,
          onTap: () {
            _customInfoWindowController.addInfoWindow!(
              CustomInfoCardWindow(location: location),
              LatLng(location.coordinates.latitude,
                  location.coordinates.longitude),
            );
          },
        ),
      );
    }

    for (var location in locationInfoController.accommodations) {
      // Construct the asset path based on MarkerId (or name or another unique identifier)
      final String assetPath = 'assets/image_markers/${location.id}.png';

      if (kDebugMode) {
        print('Marker ID: ${location.id}, Asset Path: $assetPath');
      }

      // Load the bitmap icon from the asset for each location
      final BitmapDescriptor bitmapIcon = await BitmapDescriptor.asset(
        const ImageConfiguration(size: Size(48, 48)), // Set the size as needed
        assetPath, // Use the constructed asset path
      );

      markers.add(
        Marker(
          markerId: MarkerId(location.name),
          position: LatLng(
              location.coordinates.latitude, location.coordinates.longitude),
          icon: bitmapIcon,
          onTap: () {
            _customInfoWindowController.addInfoWindow!(
              CustomInfoCardWindow(location: location),
              LatLng(location.coordinates.latitude,
                  location.coordinates.longitude),
            );
          },
        ),
      );
    }

    for (var location in locationInfoController.dining) {
      // Construct the asset path based on MarkerId (or name or another unique identifier)
      final String assetPath = 'assets/image_markers/${location.id}.png';

      if (kDebugMode) {
        print('Marker ID: ${location.id}, Asset Path: $assetPath');
      }

      // Load the bitmap icon from the asset for each location
      final BitmapDescriptor bitmapIcon = await BitmapDescriptor.asset(
        const ImageConfiguration(size: Size(48, 48)), // Set the size as needed
        assetPath, // Use the constructed asset path
      );

      markers.add(
        Marker(
          markerId: MarkerId(location.name),
          position: LatLng(
              location.coordinates.latitude, location.coordinates.longitude),
          icon: bitmapIcon,
          onTap: () {
            _customInfoWindowController.addInfoWindow!(
              CustomInfoCardWindow(location: location),
              LatLng(location.coordinates.latitude,
                  location.coordinates.longitude),
            );
          },
        ),
      );
    }

    for (var location in locationInfoController.shopping) {
      // Construct the asset path based on MarkerId (or name or another unique identifier)
      final String assetPath = 'assets/image_markers/${location.id}.png';

      if (kDebugMode) {
        print('Marker ID: ${location.id}, Asset Path: $assetPath');
      }

      // Load the bitmap icon from the asset for each location
      final BitmapDescriptor bitmapIcon = await BitmapDescriptor.asset(
        const ImageConfiguration(size: Size(48, 48)), // Set the size as needed
        assetPath, // Use the constructed asset path
      );

      markers.add(
        Marker(
          markerId: MarkerId(location.name),
          position: LatLng(
              location.coordinates.latitude, location.coordinates.longitude),
          icon: bitmapIcon,
          onTap: () {
            _customInfoWindowController.addInfoWindow!(
              CustomInfoCardWindow(location: location),
              LatLng(location.coordinates.latitude,
                  location.coordinates.longitude),
            );
          },
        ),
      );
    }

    if (kDebugMode) {
      print('Total markers loaded: ${markers.length}');
    }
    return markers;
  }

  Future<void> moveCameraToMarker(LatLng? position) async {
    final controller = await mapController.future;

    // Create a new CameraPosition with the target position and zoom level
    CameraPosition cameraPosition = CameraPosition(
      target: position!,
      zoom: 18,
    );
    // Move the camera to the new position
    await controller
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    // Trigger the onTap function for the corresponding marker
    final marker = markers.firstWhere((m) => m.position == position);
    if (marker != null) {
      marker.onTap!(); // Call the onTap function of the marker
    }

    // Reset
    selectedLocation == null;
  }

  // Move camera to a specific position
  Future<void> moveCameraToPosition(LatLng position) async {
    final GoogleMapController controller = await mapController.future;
    double currentZoomLevel = await controller.getZoomLevel();

    CameraPosition newCameraPosition = CameraPosition(
      target: position,
      zoom: currentZoomLevel,
    );

    await controller
        .animateCamera(CameraUpdate.newCameraPosition(newCameraPosition));
  }

  // Listen to location updates
  Future<void> getLocationUpdates(Function(LatLng) onLocationUpdate) async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await locationController.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await locationController.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await locationController.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await locationController.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationSubscription = locationController.onLocationChanged
        .listen((LocationData currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        LatLng newPosition =
            LatLng(currentLocation.latitude!, currentLocation.longitude!);
        onLocationUpdate(newPosition); // Update originLocation
      }
    });
  }

  // Dispose method to cancel location subscription
  void dispose() {
    locationSubscription
        ?.cancel(); // Cancel the subscription to prevent memory leaks
  }
}
