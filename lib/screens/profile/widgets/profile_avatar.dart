import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Avatar bulat dengan badge kamera di pojok kanan bawah.
class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    super.key,
    this.avatarPath,
    this.onCameraTap,
    this.diameter = 100.0,
  });

  final String? avatarPath;
  final VoidCallback? onCameraTap;
  final double diameter;

  static const _kBadgeDiameter = 26.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: diameter,
      height: diameter,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // ---- Avatar bulat ----
          Container(
            width: diameter,
            height: diameter,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.tabBarDivider, width: 1.2),
              color: AppColors.imagePlaceholder,
            ),
            child: ClipOval(
              child: avatarPath != null
                  ? Image.asset(
                      avatarPath!,
                      width: diameter,
                      height: diameter,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          _DefaultAvatarIcon(diameter: diameter),
                    )
                  : _DefaultAvatarIcon(diameter: diameter),
            ),
          ),

          // ---- Badge kamera di pojok kanan bawah ----
          Positioned(
            right: 0,
            bottom: 0,
            child: Material(
              color: Colors.white,
              shape: const CircleBorder(),
              elevation: 2,
              shadowColor: Colors.black38,
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: onCameraTap,
                child: Container(
                  width: _kBadgeDiameter,
                  height: _kBadgeDiameter,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.tabBarDivider,
                      width: 1,
                    ),
                  ),
                  child: const Icon(
                    Icons.camera_alt_rounded,
                    size: 14,
                    color: Color(0xFF666666),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DefaultAvatarIcon extends StatelessWidget {
  const _DefaultAvatarIcon({required this.diameter});

  final double diameter;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter,
      height: diameter,
      color: AppColors.imagePlaceholder,
      alignment: Alignment.center,
      child: Icon(
        Icons.person,
        size: diameter * 0.55,
        color: const Color(0xFF718096),
      ),
    );
  }
}
