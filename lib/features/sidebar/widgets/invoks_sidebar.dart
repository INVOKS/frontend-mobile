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
  SidebarMenu(title: 'Riwayat', icon: Icons.calendar_month_rounded),
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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final sidebarWidth = math.min(360.0, screenWidth * 0.61);

    return SafeArea(
      top: false,
      child: Material(
        color: SidebarColors.background,
        elevation: 12,
        child: SizedBox(
          width: sidebarWidth,
          height: double.infinity,
          child: ListView.builder(
            padding: const EdgeInsets.only(top: 22, bottom: 18),
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
