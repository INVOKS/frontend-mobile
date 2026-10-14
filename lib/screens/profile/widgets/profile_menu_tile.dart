import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Satu baris item menu profil dengan ikon (berlingkaran atau polos), label,
/// dan trailing opsional.
class ProfileMenuTile extends StatelessWidget {
  const ProfileMenuTile({
    super.key,
    required this.icon,
    required this.label,
    this.trailing,
    this.onTap,
    this.isDestructive = false,
  });

  final IconData icon;
  final String label;
  final Widget? trailing;
  final VoidCallback? onTap;

  /// Jika true, menampilkan tema destructive (merah, ikon tanpa lingkaran),
  /// contohnya tombol Logout.
  final bool isDestructive;

  static const _kTileHeight = 58.0;
  static const _kIconCircleSize = 28.0;

  @override
  Widget build(BuildContext context) {
    final textColor = isDestructive
        ? AppColors.profileLogout
        : AppColors.textPrimary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: _kTileHeight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                // ---- Ikon ----
                if (isDestructive)
                  SizedBox(
                    width: _kIconCircleSize,
                    height: _kIconCircleSize,
                    child: Icon(icon, size: 22, color: AppColors.profileLogout),
                  )
                else
                  Container(
                    width: _kIconCircleSize,
                    height: _kIconCircleSize,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.profileIconBg,
                    ),
                    alignment: Alignment.center,
                    child: Icon(icon, size: 16, color: const Color(0xFF1A1A1A)),
                  ),
                const SizedBox(width: 14),

                // ---- Label ----
                Expanded(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ),

                // ---- Trailing ----
                ?trailing,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
