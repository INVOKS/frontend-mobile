import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class BookingTabBar extends StatelessWidget {
  const BookingTabBar({
    super.key,
    this.selectedIndex = 0,
    this.onTabChanged,
  });

  final int selectedIndex;
  final ValueChanged<int>? onTabChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFE2E8F0),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildTab(
              index: 0,
              title: 'RUANGAN',
              isActive: selectedIndex == 0,
            ),
          ),
          Expanded(
            child: _buildTab(
              index: 1,
              title: 'BARANG',
              isActive: selectedIndex == 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab({
    required int index,
    required String title,
    required bool isActive,
  }) {
    return InkWell(
      onTap: () => onTabChanged?.call(index),
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                  color: isActive ? AppColors.textPrimary : const Color(0xFF94A3B8),
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
          Container(
            height: 3,
            color: isActive ? AppColors.primary : Colors.transparent,
          ),
        ],
      ),
    );
  }
}

