import 'package:flutter/material.dart';

class CustomCurvedEdges extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height);

    final firstStartCurve = Offset(0, size.height - 20);
    final firstEndCurve = Offset(30, size.height - 20);
    path.quadraticBezierTo(firstStartCurve.dx, firstStartCurve.dy,
        firstEndCurve.dx, firstEndCurve.dy);

    final secondStartCurve = Offset(0, size.height - 20);
    final secondEndCurve = Offset(size.width - 30, size.height - 20);
    path.quadraticBezierTo(secondStartCurve.dx, secondStartCurve.dy,
        secondEndCurve.dx, secondEndCurve.dy);

    final thirdStartCurve = Offset(size.width, size.height - 20);
    final thirdEndCurve = Offset(size.width, size.height);
    path.quadraticBezierTo(thirdStartCurve.dx, thirdStartCurve.dy,
        thirdEndCurve.dx, thirdEndCurve.dy);

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<dynamic> oldClipper) {
    return false;
  }
}
