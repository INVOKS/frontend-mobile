import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../data/dummy_data.dart';
import '../../features/sidebar/sidebar.dart';
import 'widgets/favorite_item_card.dart';
import 'widgets/favorite_room_card.dart';
import 'widgets/hero_banner.dart';
import 'widgets/home_app_bar.dart';
import 'widgets/section_title.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SidebarController _sidebarController = SidebarController();

  @override
  void initState() {
    super.initState();
    _sidebarController.selectMenu(0);
  }

  @override
  void dispose() {
    _sidebarController.dispose();
    super.dispose();
  }

  void _showSearchPlaceholder() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Halaman pencarian akan segera hadir.')),
    );
  }

  void _handleMenuSelected(int index) {
    _sidebarController.closeSidebar();
    if (index == 0) {
      // Sudah di Beranda
      return;
    }
    if (index == 4) {
      Navigator.of(context).pushNamed('/booking-history');
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Halaman tersebut akan segera hadir.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: HomeAppBar(
        onMenuPressed: _sidebarController.openSidebar,
        onSearchPressed: _showSearchPlaceholder,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HeroBanner(),
                const SizedBox(height: 24),
                const SectionTitle(title: 'Top 3 Ruangan Favorit'),
                ...List<Widget>.generate(
                  topFavoriteRooms.length,
                  (index) => Padding(
                    padding: EdgeInsets.only(
                      bottom: index == topFavoriteRooms.length - 1 ? 0 : 16,
                    ),
                    child: FavoriteRoomCard(
                      room: topFavoriteRooms[index],
                      rank: index + 1,
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                const SectionTitle(title: 'Top 3 Barang Favorit'),
                ...List<Widget>.generate(
                  topFavoriteItems.length,
                  (index) => Padding(
                    padding: EdgeInsets.only(
                      bottom: index == topFavoriteItems.length - 1 ? 0 : 16,
                    ),
                    child: FavoriteItemCard(
                      item: topFavoriteItems[index],
                      rank: index + 1,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
          Positioned.fill(
            child: SidebarOverlay(
              controller: _sidebarController,
              onMenuSelected: _handleMenuSelected,
            ),
          ),
        ],
      ),
    );
  }
}
