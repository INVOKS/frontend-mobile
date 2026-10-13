import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../controller/sidebar_controller.dart';
import '../models/sidebar_menu.dart';
import 'sidebar_menu_item.dart';

const _sidebarMenus = <SidebarMenu>[
  SidebarMenu(title: 'Beranda', icon: Icons.home_rounded, route: '/home'),
  SidebarMenu(title: 'Ruangan', icon: Icons.apartment_rounded),
  SidebarMenu(title: 'Barang', icon: Icons.inventory_2_rounded),
  SidebarMenu(title: 'Notifikasi', icon: Icons.notifications_rounded),
  SidebarMenu(title: 'Riwayat', icon: Icons.calendar_month_rounded, route: '/booking-history'),
  SidebarMenu(title: 'Keranjang barang', icon: Icons.shopping_bag_rounded),
  SidebarMenu(title: 'Masuk', icon: Icons.account_circle_rounded),
];

class InvoksSidebar extends StatelessWidget {
  const InvoksSidebar({
    super.key,
    required this.controller,
    required this.onMenuSelected,
  });

  final SidebarController controller;
  final ValueChanged<int> onMenuSelected;

  static double calculateWidth(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    return math.min(280.0, screenWidth * 0.59);
  }

  @override
  Widget build(BuildContext context) {
    final sidebarWidth = calculateWidth(context);

    return Material(
      color: SidebarColors.background,
      elevation: 8,
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: sidebarWidth,
          child: ListView.builder(
            padding: const EdgeInsets.only(
              left: 15,
              right: 15,
              top: 12,
              bottom: 16,
            ),
            itemCount: _sidebarMenus.length,
            itemBuilder: (context, index) {
              return SidebarMenuItem(
                menu: _sidebarMenus[index],
                isActive: index == controller.selectedMenuIndex,
                onTap: () => onMenuSelected(index),
              );
            },
          ),
        ),
      ),
    );
  }
}
