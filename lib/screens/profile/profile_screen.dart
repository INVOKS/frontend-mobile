import 'package:flutter/material.dart';

import '../../core/constants/app_assets.dart';
import '../../core/theme/app_colors.dart';
import '../../data/dummy_data.dart';
import '../../features/sidebar/sidebar.dart';
import '../../models/user_profile.dart';
import '../account_info/account_info_screen.dart';
import '../home/home_screen.dart';
import '../home/widgets/home_app_bar.dart';
import '../rooms/rooms_screen.dart';
import 'widgets/profile_header.dart';
import 'widgets/profile_menu_card.dart';
import 'widgets/profile_menu_tile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _sidebarController = SidebarController();

  // Index menu di daftar _sidebarMenus
  static const _kMenuIndexHome = 0;
  static const _kMenuIndexRooms = 1;
  static const _kMenuIndexProfile = 6;

  @override
  void initState() {
    super.initState();
    // Tandai menu Profil sebagai item terpilih di sidebar
    _sidebarController.selectMenu(_kMenuIndexProfile);
  }

  @override
  void dispose() {
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

    if (index == _kMenuIndexHome) {
      // Kembali ke Beranda
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute<void>(builder: (_) => const HomeScreen()),
        (route) => false,
      );
    } else if (index == _kMenuIndexRooms) {
      // Pindah ke Ruangan
      Navigator.of(context)
          .push(MaterialPageRoute<void>(builder: (_) => const RoomsScreen()))
          .then((_) {
            if (mounted) _sidebarController.selectMenu(_kMenuIndexProfile);
          });
    } else if (index == 4) {
      // Pindah ke Riwayat
      Navigator.of(context).pushNamed('/booking-history').then((_) {
        if (mounted) _sidebarController.selectMenu(_kMenuIndexProfile);
      });
    } else if (index == _kMenuIndexProfile) {
      // Sudah di Profil
      return;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Halaman tersebut akan segera hadir.')),
      );
    }
  }

  void _handleChangePhoto() {
    // TODO: pilih foto profil dari kamera/galeri via image_picker jika sudah terpasang
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Fitur ubah foto segera hadir.')),
    );
  }

  void _handleAccountInfo() {
    // Buka halaman Informasi Akun
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const AccountInfoScreen()));
  }

  void _handleLogout() {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi Logout'),
        content: const Text('Apakah Anda yakin ingin keluar dari akun?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              // TODO: hapus sesi autentikasi dan arahkan ke layar login
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Berhasil keluar akun.')),
              );
            },
            child: const Text(
              'Keluar',
              style: TextStyle(color: AppColors.profileLogout),
            ),
          ),
        ],
      ),
    );
  }

  void _handleAboutApp() {
    showAboutDialog(
      context: context,
      applicationName: 'INVOKS',
      applicationVersion: '1.0.0',
      applicationIcon: Image.asset(
        AppAssets.logo,
        width: 44,
        height: 44,
        errorBuilder: (context, error, stackTrace) => const Icon(
          Icons.view_in_ar_rounded,
          size: 44,
          color: AppColors.primary,
        ),
      ),
      children: const [
        Text(
          'INVOKS adalah sistem informasi peminjaman fasilitas ruangan dan barang vokasi.',
        ),
      ],
    );
  }

  void _handleChangePassword() {
    // TODO: buka halaman ubah password
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Halaman ubah password akan segera hadir.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // ---- Scaffold utama ----
        Scaffold(
          backgroundColor: AppColors.background,
          appBar: HomeAppBar(
            onMenuPressed: _sidebarController.openSidebar,
            onSearchPressed: _showSearchPlaceholder,
          ),
          body: ValueListenableBuilder<UserProfile>(
            valueListenable: userProfileNotifier,
            builder: (context, user, child) {
              return CustomScrollView(
                slivers: [
                  // ---- Area atas: terang (identitas profil) ----
                  SliverToBoxAdapter(
                    child: ProfileHeader(
                      user: user,
                      onChangePhoto: _handleChangePhoto,
                    ),
                  ),

                  // ---- Area bawah: biru INVOKS mengisi sisa tinggi ----
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(24),
                        ),
                      ),
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Kartu 1: Informasi akun & Logout
                          ProfileMenuCard(
                            items: [
                              ProfileMenuTile(
                                icon: Icons.person,
                                label: 'Informasi akun',
                                trailing: const Icon(
                                  Icons.edit_outlined,
                                  size: 19,
                                  color: Colors.black,
                                ),
                                onTap: _handleAccountInfo,
                              ),
                              ProfileMenuTile(
                                icon: Icons.logout_rounded,
                                label: 'Logout',
                                isDestructive: true,
                                onTap: _handleLogout,
                              ),
                            ],
                          ),
                          const SizedBox(height: 28),

                          // Heading "Lebih banyak"
                          const Text(
                            'Lebih banyak',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Kartu 2: Tentang aplikasi & Ubah password
                          ProfileMenuCard(
                            items: [
                              ProfileMenuTile(
                                icon: Icons.info_outline_rounded,
                                label: 'Tentang aplikasi',
                                onTap: _handleAboutApp,
                              ),
                              ProfileMenuTile(
                                icon: Icons.lock_outline_rounded,
                                label: 'Ubah password',
                                onTap: _handleChangePassword,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),

        // ---- Sidebar overlay ----
        SidebarOverlay(
          controller: _sidebarController,
          onMenuSelected: _onMenuSelected,
        ),
      ],
    );
  }
}
