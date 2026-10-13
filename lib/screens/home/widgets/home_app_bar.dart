import 'package:flutter/material.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/theme/app_colors.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({
    super.key,
    required this.onMenuPressed,
    required this.onSearchPressed,
  });

  final VoidCallback onMenuPressed;
  final VoidCallback onSearchPressed;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        tooltip: 'Buka menu',
        onPressed: onMenuPressed,
        icon: const Icon(Icons.menu),
      ),
      titleSpacing: 0,
      title: Row(
        children: [
          Image.asset(
            AppAssets.logo,
            height: 28,
            semanticLabel: 'Logo INVOKS',
            errorBuilder: (context, error, stackTrace) => const Icon(
              Icons.view_in_ar_rounded,
              size: 28,
              color: AppColors.badge,
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            'INVOKS',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
        ],
      ),
      actions: [
        IconButton(
          tooltip: 'Cari',
          onPressed: onSearchPressed,
          icon: const Icon(Icons.search),
        ),
      ],
    );
  }
}
