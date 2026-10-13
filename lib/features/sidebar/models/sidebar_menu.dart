import 'package:flutter/material.dart';

class SidebarMenu {
  const SidebarMenu({
    required this.title,
    required this.icon,
    this.route,
  });

  final String title;
  final IconData icon;
  final String? route;
}
