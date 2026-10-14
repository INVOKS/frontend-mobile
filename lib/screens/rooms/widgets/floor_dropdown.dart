import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Dropdown "Pilih lantai" — rata kanan.
///
/// [floorNames] adalah daftar lantai sesuai gedung aktif (tanpa opsi reset).
/// Opsi "Semua lantai" selalu ditambahkan di paling atas secara internal.
/// [selectedFloor] null berarti "Semua lantai" / belum dipilih.
class FloorDropdown extends StatelessWidget {
  const FloorDropdown({
    super.key,
    required this.floorNames,
    required this.selectedFloor,
    required this.onChanged,
  });

  final List<String> floorNames;
  final String? selectedFloor;
  final ValueChanged<String?> onChanged;

  static const _kHeight = 36.0;
  static const _kWidth = 175.0;
  static const _kPlaceholder = 'Pilih lantai';
  static const _kAllFloors = 'Semua lantai';

  @override
  Widget build(BuildContext context) {
    final items = <DropdownMenuItem<String?>>[
      DropdownMenuItem<String?>(
        value: null,
        child: Text(
          _kAllFloors,
          style: TextStyle(
            fontSize: 13,
            color: AppColors.textPrimary.withValues(alpha: 0.7),
          ),
        ),
      ),
      ...floorNames.map(
        (floor) => DropdownMenuItem<String?>(
          value: floor,
          child: Text(
            floor,
            style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
          ),
        ),
      ),
    ];

    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 16, top: 14, bottom: 14),
        child: Container(
          height: _kHeight,
          width: _kWidth,
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: AppColors.tabBarDivider),
            boxShadow: const [
              BoxShadow(
                color: Color(0x14000000),
                blurRadius: 4,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: DropdownButtonHideUnderline(
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButton<String?>(
                value: selectedFloor,
                hint: Text(
                  _kPlaceholder,
                  style: TextStyle(fontSize: 13, color: AppColors.tabInactive),
                ),
                icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 20),
                iconEnabledColor: AppColors.tabInactive,
                isDense: true,
                isExpanded: true,
                items: items,
                onChanged: onChanged,
                borderRadius: BorderRadius.circular(6),
                dropdownColor: AppColors.card,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
