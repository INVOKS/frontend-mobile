import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../models/room.dart';
import 'rank_badge.dart';

class FavoriteRoomCard extends StatelessWidget {
  const FavoriteRoomCard({super.key, required this.room, required this.rank});

  final Room room;
  final int rank;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          RankBadge(rank: rank),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              height: 84,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x24000000),
                    blurRadius: 9,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  _FavoriteThumbnail(
                    imagePath: room.imagePath,
                    semanticLabel: room.name,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          room.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          room.capacityLabel,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FavoriteThumbnail extends StatelessWidget {
  const _FavoriteThumbnail({
    required this.imagePath,
    required this.semanticLabel,
  });

  final String imagePath;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(7),
      child: Image.asset(
        imagePath,
        width: 64,
        height: 58,
        fit: BoxFit.cover,
        semanticLabel: semanticLabel,
        errorBuilder: (context, error, stackTrace) =>
            const _ImagePlaceholder(icon: Icons.meeting_room_outlined),
      ),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 58,
      color: AppColors.imagePlaceholder,
      alignment: Alignment.center,
      child: Icon(icon, color: AppColors.primary, size: 25),
    );
  }
}
