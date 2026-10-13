import 'package:flutter/material.dart';

import '../models/sidebar_menu.dart';

abstract final class SidebarColors {
  static const header = Color(0xFF0871A8);
  static const background = Color(0xFF193775);
  static const activeItem = Color(0xFF52699B);
  static const icon = Colors.white;
  static const text = Colors.white;
}

class SidebarMenuItem extends StatelessWidget {
  const SidebarMenuItem({
    super.key,
    required this.menu,
    required this.isActive,
    required this.onTap,
  });

  final SidebarMenu menu;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isActive,
      label: menu.title,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(11),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          height: 48,
          decoration: BoxDecoration(
            color: isActive ? SidebarColors.activeItem : Colors.transparent,
            borderRadius: BorderRadius.circular(11),
          ),
          child: Row(
            children: [
              Icon(menu.icon, size: 24, color: SidebarColors.icon),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  menu.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: SidebarColors.text,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
