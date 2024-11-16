import 'package:flutter/material.dart';

class ListViewLayout extends StatelessWidget {
  const ListViewLayout({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    required this.scrollDirection,
  });

  final int itemCount;
  final Axis scrollDirection;
  final Widget? Function(BuildContext, int) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: scrollDirection,
      itemCount: itemCount,
      itemBuilder: itemBuilder,
    );
  }
}
