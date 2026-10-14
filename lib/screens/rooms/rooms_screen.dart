import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../data/dummy_data.dart';
import '../../features/sidebar/sidebar.dart';
import '../../models/room.dart';
import '../home/widgets/home_app_bar.dart';
import '../profile/profile_screen.dart';
import 'widgets/building_tab_bar.dart';
import 'widgets/floor_dropdown.dart';
import 'widgets/floor_header.dart';
import 'widgets/room_timeline_tile.dart';

class RoomsScreen extends StatefulWidget {
  const RoomsScreen({super.key});

  @override
  State<RoomsScreen> createState() => _RoomsScreenState();
}

class _RoomsScreenState extends State<RoomsScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  final _sidebarController = SidebarController();

  // Index menu Ruangan di daftar sidebar (index 1)
  static const _kMenuIndexRooms = 1;

  /// Lantai yang dipilih per tab-index (null = Semua lantai).
  final Map<int, String?> _selectedFloor = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: buildingNames.length, vsync: this)
      ..addListener(_onTabChanged);
    // Tandai menu Ruangan sebagai aktif
    _sidebarController.selectMenu(_kMenuIndexRooms);
  }

  void _onTabChanged() {
    // Reset dropdown saat tab berubah (hanya saat animasi selesai)
    if (!_tabController.indexIsChanging) {
      setState(() {
        _selectedFloor[_tabController.index] = null;
      });
    }
  }

  @override
  void dispose() {
    _tabController
      ..removeListener(_onTabChanged)
      ..dispose();
    _sidebarController.dispose();
    super.dispose();
  }

  void _showSearchPlaceholder() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Fitur pencarian akan segera hadir.')),
    );
  }

  void _onMenuSelected(int index) {
    _sidebarController
      ..selectMenu(index)
      ..closeSidebar();

    // Index 0 = Beranda → kembali ke Home
    if (index == 0) {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      } else {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } else if (index == 1) {
      // Sudah di Ruangan
      return;
    } else if (index == 4) {
      Navigator.of(context).pushNamed('/booking-history').then((_) {
        if (mounted) _sidebarController.selectMenu(_kMenuIndexRooms);
      });
    } else if (index == 6) {
      // Pindah ke Profil
      Navigator.of(context)
          .push(MaterialPageRoute<void>(builder: (_) => const ProfileScreen()))
          .then((_) {
            if (mounted) _sidebarController.selectMenu(_kMenuIndexRooms);
          });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Halaman tersebut akan segera hadir.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // ---- Scaffold utama ------------------------------------------
        Scaffold(
          backgroundColor: AppColors.background,
          appBar: HomeAppBar(
            onMenuPressed: _sidebarController.openSidebar,
            onSearchPressed: _showSearchPlaceholder,
          ),
          body: Column(
            children: [
              // ---- Tab bar gedung ------------------------------------
              BuildingTabBar(
                tabController: _tabController,
                labels: buildingNames,
              ),

              // ---- Konten tab ----------------------------------------
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: List<Widget>.generate(
                    buildingNames.length,
                    (tabIndex) => _BuildingTabContent(
                      key: PageStorageKey<String>(buildingNames[tabIndex]),
                      buildingName: buildingNames[tabIndex],
                      selectedFloor: _selectedFloor[tabIndex],
                      onFloorChanged: (floor) =>
                          setState(() => _selectedFloor[tabIndex] = floor),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // ---- Sidebar overlay -----------------------------------------
        SidebarOverlay(
          controller: _sidebarController,
          onMenuSelected: _onMenuSelected,
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Konten satu tab gedung
// ---------------------------------------------------------------------------

class _BuildingTabContent extends StatelessWidget {
  const _BuildingTabContent({
    super.key,
    required this.buildingName,
    required this.selectedFloor,
    required this.onFloorChanged,
  });

  final String buildingName;
  final String? selectedFloor;
  final ValueChanged<String?> onFloorChanged;

  @override
  Widget build(BuildContext context) {
    final floorNames = floorNamesOf(buildingName);
    final floorRoomsMap = roomsByFloor(buildingName);

    // Filter berdasarkan pilihan lantai
    final displayedFloors = selectedFloor != null
        ? floorNames.where((f) => f == selectedFloor).toList()
        : floorNames;

    return CustomScrollView(
      slivers: [
        // ---- Dropdown pilih lantai ------------------------------------
        SliverToBoxAdapter(
          child: FloorDropdown(
            floorNames: floorNames,
            selectedFloor: selectedFloor,
            onChanged: onFloorChanged,
          ),
        ),

        // ---- Daftar lantai + ruangan ----------------------------------
        for (final floorName in displayedFloors) ...[
          SliverToBoxAdapter(child: FloorHeader(floorName: floorName)),
          _RoomFloorSliver(rooms: floorRoomsMap[floorName] ?? const []),
        ],

        // ---- Padding bawah -------------------------------------------
        const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Sliver daftar ruangan dalam satu lantai
// ---------------------------------------------------------------------------

class _RoomFloorSliver extends StatelessWidget {
  const _RoomFloorSliver({required this.rooms});

  final List<Room> rooms;

  @override
  Widget build(BuildContext context) {
    if (rooms.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final room = rooms[index];
        final TimelinePosition position;
        if (rooms.length == 1) {
          position = TimelinePosition.only;
        } else if (index == 0) {
          position = TimelinePosition.first;
        } else if (index == rooms.length - 1) {
          position = TimelinePosition.last;
        } else {
          position = TimelinePosition.middle;
        }

        return RoomTimelineTile(
          room: room,
          position: position,
          onTap: () {
            // TODO: buka detail ruangan
          },
        );
      }, childCount: rooms.length),
    );
  }
}
