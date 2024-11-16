import 'package:flutter/material.dart';

import '../curved_edges/curved_edges_widget.dart';

class PrimaryHeaderContainer extends StatelessWidget {
  const PrimaryHeaderContainer({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CurvedEdgesWidget(
      child: Container(
        padding: const EdgeInsets.all(0),
        child: Stack(
          children: [
            child,
          ],
        ),
      ),
    );
  }
}
