import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Kartu putih dengan sudut membulat ±16px berisi daftar item menu
/// yang otomatis dipisahkan dengan divider tipis.
class ProfileMenuCard extends StatelessWidget {
  const ProfileMenuCard({super.key, required this.items});

  final List<Widget> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x18000000),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (int i = 0; i < items.length; i++) ...[
              items[i],
              if (i < items.length - 1)
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: AppColors.profileDivider,
                ),
            ],
          ],
        ),
      ),
    );
  }
}
