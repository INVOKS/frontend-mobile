import 'package:flutter/material.dart';

import '../controller/sidebar_controller.dart';
import 'invoks_sidebar.dart';

class SidebarOverlay extends StatelessWidget {
  const SidebarOverlay({
    super.key,
    required this.controller,
    required this.onMenuSelected,
  });

  final SidebarController controller;
  final ValueChanged<int> onMenuSelected;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final sidebarWidth = InvoksSidebar.calculateWidth(context);
        final isOpen = controller.isOpen;

        return IgnorePointer(
          ignoring: !isOpen,
          child: Stack(
            children: [
              // Background gelap ketika sidebar terbuka
              if (isOpen)
                Positioned.fill(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: controller.closeSidebar,
                    child: ColoredBox(
                      color: Colors.black.withValues(alpha: 0.12),
                    ),
                  ),
                ),

              // Sidebar
              AnimatedPositioned(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                left: isOpen ? 0 : -sidebarWidth,
                top: 0,
                bottom: 0,
                width: sidebarWidth,
                child: InvoksSidebar(
                  controller: controller,
                  onMenuSelected: onMenuSelected,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}