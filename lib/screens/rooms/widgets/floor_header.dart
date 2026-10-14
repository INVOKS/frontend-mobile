import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Bar kuning selebar layar sebagai header nama lantai.
class FloorHeader extends StatelessWidget {
  const FloorHeader({super.key, required this.floorName});

  final String floorName;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 34,
      color: AppColors.floorHeader,
      alignment: Alignment.center,
      child: Text(
        floorName,
        style: const TextStyle(
          color: AppColors.floorHeaderText,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
