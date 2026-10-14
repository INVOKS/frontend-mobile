import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Field dropdown gender dengan menu pop-up di sisi kanan sesuai desain.
class GenderDropdownField extends StatefulWidget {
  const GenderDropdownField({
    super.key,
    this.initialValue,
    required this.onChanged,
  });

  final String? initialValue;
  final ValueChanged<String?> onChanged;

  static const List<String> options = ['Perempuan', 'Laki Laki'];

  @override
  State<GenderDropdownField> createState() => _GenderDropdownFieldState();
}

class _GenderDropdownFieldState extends State<GenderDropdownField> {
  final _fieldKey = GlobalKey();
  String? _selectedValue;
  bool _isOpen = false;
  OverlayEntry? _overlayEntry;

  static const _kMenuWidth = 175.0;
  static const _kItemHeight = 46.0;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue;
  }

  @override
  void didUpdateWidget(GenderDropdownField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue) {
      _selectedValue = widget.initialValue;
    }
  }

  @override
  void dispose() {
    _closeMenu();
    super.dispose();
  }

  void _toggleMenu() {
    if (_isOpen) {
      _closeMenu();
    } else {
      _openMenu();
    }
  }

  void _openMenu() {
    final renderBox =
        _fieldKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final fieldOffset = renderBox.localToGlobal(Offset.zero);
    final fieldSize = renderBox.size;

    final overlay = Overlay.of(context);
    final entry = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            // Tap di luar untuk menutup
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: _closeMenu,
              ),
            ),

            // Pop-up menu di sisi kanan field
            Positioned(
              left: fieldOffset.dx + fieldSize.width - _kMenuWidth,
              top: fieldOffset.dy,
              width: _kMenuWidth,
              child: Material(
                color: Colors.white,
                elevation: 4,
                shadowColor: Colors.black26,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.tabBarDivider,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header menu (Pilih gender + chevron up)
                      InkWell(
                        onTap: _closeMenu,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(8),
                        ),
                        child: Container(
                          height: _kItemHeight,
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Pilih gender',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.tabInactive,
                                ),
                              ),
                              Icon(
                                Icons.keyboard_arrow_up_rounded,
                                size: 20,
                                color: AppColors.tabInactive,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: AppColors.profileDivider,
                      ),

                      // Opsi gender
                      for (
                        int i = 0;
                        i < GenderDropdownField.options.length;
                        i++
                      ) ...[
                        _buildOptionTile(
                          GenderDropdownField.options[i],
                          isLast: i == GenderDropdownField.options.length - 1,
                        ),
                        if (i < GenderDropdownField.options.length - 1)
                          const Divider(
                            height: 1,
                            thickness: 1,
                            color: AppColors.profileDivider,
                          ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );

    overlay.insert(entry);
    setState(() {
      _overlayEntry = entry;
      _isOpen = true;
    });
  }

  Widget _buildOptionTile(String option, {required bool isLast}) {
    final isSelected = _selectedValue == option;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedValue = option;
        });
        widget.onChanged(option);
        _closeMenu();
      },
      borderRadius: isLast
          ? const BorderRadius.vertical(bottom: Radius.circular(8))
          : BorderRadius.zero,
      child: Container(
        height: _kItemHeight,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        alignment: Alignment.centerLeft,
        child: Text(
          option,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }

  void _closeMenu() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (mounted && _isOpen) {
      setState(() {
        _isOpen = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasValue = _selectedValue != null && _selectedValue!.isNotEmpty;

    return InkWell(
      key: _fieldKey,
      onTap: _toggleMenu,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _isOpen ? AppColors.primary : AppColors.roomCardBorder,
            width: _isOpen ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              hasValue ? _selectedValue! : 'Pilih gender',
              style: TextStyle(
                fontSize: 14,
                fontWeight: hasValue ? FontWeight.w500 : FontWeight.normal,
                color: hasValue ? AppColors.textPrimary : AppColors.tabInactive,
              ),
            ),
            Icon(
              _isOpen
                  ? Icons.keyboard_arrow_up_rounded
                  : Icons.keyboard_arrow_down_rounded,
              size: 22,
              color: AppColors.tabInactive,
            ),
          ],
        ),
      ),
    );
  }
}
