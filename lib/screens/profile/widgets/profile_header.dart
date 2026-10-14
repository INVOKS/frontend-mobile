import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../models/user_profile.dart';
import 'profile_avatar.dart';

/// Bagian header profil: judul "Profil", avatar bulat dengan badge kamera,
/// nama pengguna, dan email.
class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, required this.user, this.onChangePhoto});

  final UserProfile user;
  final VoidCallback? onChangePhoto;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 24),
        // Judul Profil
        const Text(
          'Profil',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 28),

        // Avatar + badge kamera
        ProfileAvatar(avatarPath: user.avatarPath, onCameraTap: onChangePhoto),
        const SizedBox(height: 22),

        // Nama pengguna
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            user.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        const SizedBox(height: 4),

        // Email
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            user.email,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppColors.profileEmail,
            ),
          ),
        ),
        const SizedBox(height: 28),
      ],
    );
  }
}
