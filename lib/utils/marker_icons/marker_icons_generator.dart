
import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image/image.dart' as img;
import 'package:http/http.dart' as http;

class MarkerIconGenerator {
  static Future<BitmapDescriptor?> generateMarkerIcon(
      String thumbnailUrl, double desiredWidth) async {
    try {
      // Check if the file exists in the cache
      FileInfo? fileInfo = await DefaultCacheManager().getFileFromCache(thumbnailUrl);
      if (fileInfo != null) {
        // If file exists in the cache, read its bytes
        Uint8List bytes = await fileInfo.file.readAsBytes();
        // Resize the image
        Uint8List resizedBytes = await _resizeImage(bytes, desiredWidth);
        // Create BitmapDescriptor from the bytes
        return BitmapDescriptor.fromBytes(resizedBytes);
      } else {
        // If file not found in cache, download it from the network
        http.Response response = await http.get(Uri.parse(thumbnailUrl));
        if (response.statusCode == 200) {
          // Read the downloaded bytes
          Uint8List bytes = response.bodyBytes;
          // Resize the image
          Uint8List resizedBytes = await _resizeImage(bytes, desiredWidth);
          // Store the resized image in cache
          await DefaultCacheManager().putFile(
            thumbnailUrl,
            resizedBytes,
            key: thumbnailUrl,
            maxAge: const Duration(days: 7), // Adjust cache duration as needed
          );
          // Create BitmapDescriptor from the resized image bytes
          return BitmapDescriptor.fromBytes(resizedBytes);
        } else {
          if (kDebugMode) {
            print('Failed to download image from network: ${response.statusCode}');
          }
          return null;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error generating marker icon: $e');
      }
      return null;
    }
  }

  static Future<Uint8List> _resizeImage(Uint8List imageBytes, double width) async {
    // Decode the image
    img.Image image = img.decodeImage(imageBytes)!;

    /* LOADS TOO SLOW
    // Calculate aspect ratio of original image
    double aspectRatio = image.width / image.height;

    // Calculate new width and height while maintaining aspect ratio
    if (width != null && height == null) {
      height = width / aspectRatio;
    } else if (width == null && height != null) {
      width = height * aspectRatio;
    } else if (width != null && height != null) {
      // Adjust the logic here to set the correct dimensions
      if (width / height > aspectRatio) {
        width = height * aspectRatio;
      } else {
        height = width / aspectRatio;
      }
    }
     */

    // Resize the image
    img.Image resizedImage = img.copyResizeCropSquare(image, size: width.toInt());
    // decodeImageFromList(image.buffer.asUint8List(), width: 40);

    // Encode the resized image to bytes
    Uint8List resizedBytes = Uint8List.fromList(img.encodePng(resizedImage));

    return resizedBytes;
  }
}
