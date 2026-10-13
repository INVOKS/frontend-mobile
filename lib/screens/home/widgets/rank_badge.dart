import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class RankBadge extends StatelessWidget {
  const RankBadge({super.key, required this.rank});

  final int rank;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Peringkat $rank',
      child: Container(
        width: 38,
        height: 38,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.badge,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.badgeBorder, width: 1),
        ),
        child: Text(
          '$rank',
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
