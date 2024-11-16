import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../constants/image_strings.dart';

Future<BitmapDescriptor> getCustomIcon(String thumbnail, String name, Color color) async {
  // Create a widget that represents your custom marker
  final widget = Stack(
    children: [
      SizedBox(
        width: 50,
        height: 50,
        child: Center(
          child: Icon(
            Icons.place,
            color: color,
            size: 50,
          ),
        ),
      ),
      Positioned(
        left: 5,
        child: CircleAvatar(
          radius: 20,
          backgroundColor: color,
          child: CircleAvatar(
            radius: 18, // Adjust to make the border visible
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 16, // Inner radius
              backgroundImage: thumbnail.isNotEmpty
                  ? CachedNetworkImageProvider(thumbnail) as ImageProvider
                  : const AssetImage(MAppImages.defaultLocationImage),
            ),
          ),
        ),
      ),
    ],
  );

  // Render the widget to an image and convert to BitmapDescriptor
  return await _widgetToBitmapDescriptor(widget);
}

Future<BitmapDescriptor> _widgetToBitmapDescriptor(Widget widget) async {
  // Convert the widget to a bitmap
  RenderRepaintBoundary boundary = RenderRepaintBoundary();
  final image = await boundary.toImage(pixelRatio: 3.0);
  final byteData = await image.toByteData(format: ImageByteFormat.png);
  final uint8List = byteData!.buffer.asUint8List();
  return BitmapDescriptor.bytes(uint8List);
}
