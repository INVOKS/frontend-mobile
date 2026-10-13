import 'package:flutter/material.dart';

import '../../../core/constants/app_assets.dart';
import 'sidebar_menu_item.dart';

class SidebarHeader extends StatelessWidget {
  const SidebarHeader({
    super.key,
    required this.onMenuTap,
    required this.onSearchTap,
  });

  final VoidCallback onMenuTap;
  final VoidCallback onSearchTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 115,
      color: SidebarColors.header,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              IconButton(
                tooltip: 'Tutup menu',
                onPressed: onMenuTap,
                icon: const Icon(Icons.menu, color: Colors.white, size: 26),
              ),
              const SizedBox(width: 4),
              Image.asset(
                AppAssets.logo,
                height: 30,
                semanticLabel: 'Logo INVOKS',
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.view_in_ar_rounded,
                  color: Color(0xFFFFE100),
                  size: 30,
                ),
              ),
              const SizedBox(width: 7),
              const Text(
                'INVOKS',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Spacer(),
              IconButton(
                tooltip: 'Cari',
                onPressed: onSearchTap,
                icon: const Icon(Icons.search, color: Colors.white, size: 28),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
