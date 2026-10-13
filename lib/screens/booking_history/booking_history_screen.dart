import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../data/booking_history_dummy.dart';
import '../../features/sidebar/sidebar.dart';
import '../../models/booking_history.dart';
import '../home/widgets/home_app_bar.dart';
import 'widgets/booking_card.dart';
import 'widgets/booking_filter_dropdown.dart';
import 'widgets/booking_tab_bar.dart';

export 'widgets/booking_filter_dropdown.dart' show BookingHistoryFilter;

class BookingHistoryScreen extends StatefulWidget {
  const BookingHistoryScreen({super.key});

  @override
  State<BookingHistoryScreen> createState() => _BookingHistoryScreenState();
}

class _BookingHistoryScreenState extends State<BookingHistoryScreen> {
  final SidebarController _sidebarController = SidebarController();
  BookingHistoryFilter _selectedFilter = BookingHistoryFilter.all;
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _sidebarController.selectMenu(4);
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
    if (index == 4) {
      // Sudah di halaman Riwayat
      return;
    }
    if (index == 0) {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      } else {
        Navigator.of(context).pushReplacementNamed('/home');
      }
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Halaman tersebut akan segera hadir.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredBookings = switch (_selectedFilter) {
      BookingHistoryFilter.all => roomBookingHistoryDummy,
      BookingHistoryFilter.upcoming => roomBookingHistoryDummy
          .where((booking) => booking.status == BookingStatus.upcoming)
          .toList(),
      BookingHistoryFilter.completed => roomBookingHistoryDummy
          .where((booking) => booking.status == BookingStatus.completed)
          .toList(),
    };

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: HomeAppBar(
        onMenuPressed: _sidebarController.openSidebar,
        onSearchPressed: _showSearchPlaceholder,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              BookingTabBar(
                selectedIndex: _selectedTabIndex,
                onTabChanged: (index) {
                  setState(() {
                    _selectedTabIndex = index;
                  });
                },
              ),
              Expanded(
                child: _selectedTabIndex == 0
                    ? ListView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: BookingFilterDropdown(
                              value: _selectedFilter,
                              onChanged: (filter) {
                                setState(() {
                                  _selectedFilter = filter;
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 12),
                          if (filteredBookings.isEmpty)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 40),
                              child: Center(
                                child: Text(
                                  'Tidak ada riwayat booking.',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                              ),
                            )
                          else
                            ...filteredBookings.map(
                              (booking) => Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: BookingCard(booking: booking),
                              ),
                            ),
                        ],
                      )
                    : const Center(
                        child: Text(
                          'Riwayat booking barang akan segera hadir.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ),
              ),
            ],
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

