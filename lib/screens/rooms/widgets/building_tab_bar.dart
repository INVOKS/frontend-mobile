import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Tab bar tiga gedung: BNI / Dieng / KP.
///
/// Gunakan bersama [TabController] yang sudah dibuat di parent.
class BuildingTabBar extends StatelessWidget implements PreferredSizeWidget {
  const BuildingTabBar({
    super.key,
    required this.tabController,
    required this.labels,
  });

  final TabController tabController;
  final List<String> labels;

  @override
  Size get preferredSize => const Size.fromHeight(44);

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.card,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TabBar(
            controller: tabController,
            tabs: labels
                .map(
                  (label) => Tab(
                    child: Text(
                      'GEDUNG ${label.toUpperCase()}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                )
                .toList(),
            labelColor: AppColors.tabActive,
            unselectedLabelColor: AppColors.tabInactive,
            indicatorColor: AppColors.tabIndicator,
            indicatorWeight: 3,
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: AppColors.tabBarDivider,
            dividerHeight: 1.5,
            splashFactory: InkRipple.splashFactory,
            overlayColor: WidgetStateProperty.all(
              AppColors.primary.withValues(alpha: 0.08),
            ),
          ),
        ],
      ),
    );
  }
}
