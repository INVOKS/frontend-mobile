import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_colors.dart';
import '../../data/dummy_data.dart';
import '../../features/sidebar/sidebar.dart';
import '../../models/user_profile.dart';
import '../home/home_screen.dart';
import '../home/widgets/home_app_bar.dart';
import '../profile/widgets/profile_avatar.dart';
import '../rooms/rooms_screen.dart';
import 'widgets/account_text_field.dart';
import 'widgets/date_picker_field.dart';
import 'widgets/gender_dropdown_field.dart';

class AccountInfoScreen extends StatefulWidget {
  const AccountInfoScreen({super.key});

  @override
  State<AccountInfoScreen> createState() => _AccountInfoScreenState();
}

class _AccountInfoScreenState extends State<AccountInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _sidebarController = SidebarController();

  static const _kMenuIndexHome = 0;
  static const _kMenuIndexRooms = 1;
  static const _kMenuIndexProfile = 6;

  // Controllers
  late final TextEditingController _nameController;
  late final TextEditingController _majorController;
  late final TextEditingController _batchController;
  late final TextEditingController _phoneController;

  String? _selectedGender;
  DateTime? _selectedBirthDate;
  bool _isSaving = false;
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  @override
  void initState() {
    super.initState();
    _sidebarController.selectMenu(_kMenuIndexProfile);

    final initial = userProfileNotifier.value;
    _nameController = TextEditingController(text: initial.name);
    _majorController = TextEditingController(text: initial.major ?? '');
    _batchController = TextEditingController(text: initial.batch ?? '');
    _phoneController = TextEditingController(text: initial.phone ?? '');
    _selectedGender = initial.gender;
    _selectedBirthDate = initial.birthDate;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _majorController.dispose();
    _batchController.dispose();
    _phoneController.dispose();
    _sidebarController.dispose();
    super.dispose();
  }

  bool get _hasUnsavedChanges {
    final current = userProfileNotifier.value;
    return _nameController.text.trim() != current.name ||
        _majorController.text.trim() != (current.major ?? '') ||
        _batchController.text.trim() != (current.batch ?? '') ||
        _phoneController.text.trim() != (current.phone ?? '') ||
        _selectedGender != current.gender ||
        _selectedBirthDate != current.birthDate;
  }

  Future<bool> _handlePopCheck() async {
    if (!_hasUnsavedChanges) return true;

    final shouldLeave = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Perubahan belum disimpan'),
        content: const Text(
          'Anda memiliki perubahan yang belum disimpan. Yakin ingin keluar?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text(
              'Keluar',
              style: TextStyle(color: AppColors.profileLogout),
            ),
          ),
        ],
      ),
    );

    return shouldLeave ?? false;
  }

  void _onMenuSelected(int index) {
    _sidebarController
      ..selectMenu(index)
      ..closeSidebar();

    if (index == _kMenuIndexHome) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute<void>(builder: (_) => const HomeScreen()),
        (route) => false,
      );
    } else if (index == _kMenuIndexRooms) {
      Navigator.of(context)
          .push(MaterialPageRoute<void>(builder: (_) => const RoomsScreen()));
    } else if (index == _kMenuIndexProfile) {
      // Kembali ke halaman profil
      Navigator.of(context).pop();
    }
  }

  void _showSearchPlaceholder() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Fitur pencarian akan segera hadir.')),
    );
  }

  void _handleChangePhoto() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Fitur ubah foto segera hadir.')),
    );
  }

  void _saveProfile() {
    setState(() {
      _autovalidateMode = AutovalidateMode.onUserInteraction;
    });

    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    // Perbarui data user di Single Source of Truth
    // TODO: integrasikan dengan endpoint API backend
    final updatedProfile = userProfileNotifier.value.copyWith(
      name: _nameController.text.trim(),
      gender: _selectedGender,
      birthDate: _selectedBirthDate,
      major: _majorController.text.trim().isEmpty
          ? null
          : _majorController.text.trim(),
      batch: _batchController.text.trim().isEmpty
          ? null
          : _batchController.text.trim(),
      phone: _phoneController.text.trim().isEmpty
          ? null
          : _phoneController.text.trim(),
    );

    userProfileNotifier.value = updatedProfile;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Informasi akun berhasil disimpan')),
    );

    // Kembali ke halaman Profil
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final canLeave = await _handlePopCheck();
        if (canLeave && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: AppColors.background,
            appBar: HomeAppBar(
              onMenuPressed: _sidebarController.openSidebar,
              onSearchPressed: _showSearchPlaceholder,
            ),
            body: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => FocusScope.of(context).unfocus(),
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 40),
                child: ValueListenableBuilder<UserProfile>(
                  valueListenable: userProfileNotifier,
                  builder: (context, user, child) {
                    return Form(
                      key: _formKey,
                      autovalidateMode: _autovalidateMode,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 12),

                          // ---- Baris tombol kembali & judul ----
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.arrow_back_rounded,
                                      size: 26,
                                      color: AppColors.primary,
                                    ),
                                    onPressed: () async {
                                      final canLeave = await _handlePopCheck();
                                      if (canLeave && context.mounted) {
                                        Navigator.of(context).pop();
                                      }
                                    },
                                  ),
                                ),
                                const Text(
                                  'Informasi akun',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 18),

                          // ---- Identitas Pengguna ----
                          ProfileAvatar(
                            avatarPath: user.avatarPath,
                            onCameraTap: _handleChangePhoto,
                          ),
                          const SizedBox(height: 18),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Text(
                              user.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Text(
                              user.email,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.profileEmail,
                              ),
                            ),
                          ),
                          const SizedBox(height: 28),

                          // ---- Form Fields ----
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: Column(
                              children: [
                                // 1. Nama Lengkap
                                AccountTextField(
                                  controller: _nameController,
                                  hintText: 'Nama Lengkap',
                                  keyboardType: TextInputType.name,
                                  textCapitalization: TextCapitalization.words,
                                  validator: (value) {
                                    final trimmed = value?.trim() ?? '';
                                    if (trimmed.isEmpty) {
                                      return 'Nama lengkap wajib diisi';
                                    }
                                    if (trimmed.length < 3) {
                                      return 'Nama minimal 3 karakter';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),

                                // 2. Gender
                                GenderDropdownField(
                                  initialValue: _selectedGender,
                                  onChanged: (gender) {
                                    setState(() {
                                      _selectedGender = gender;
                                    });
                                  },
                                ),
                                const SizedBox(height: 16),

                                // 3. Tanggal lahir
                                DatePickerField(
                                  initialDate: _selectedBirthDate,
                                  onDateSelected: (date) {
                                    setState(() {
                                      _selectedBirthDate = date;
                                    });
                                  },
                                  validator: (_) {
                                    if (_selectedBirthDate != null &&
                                        _selectedBirthDate!.isAfter(
                                          DateTime.now(),
                                        )) {
                                      return 'Tanggal lahir tidak boleh di masa depan';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),

                                // 4. Jurusan
                                AccountTextField(
                                  controller: _majorController,
                                  hintText: 'Jurusan',
                                  textCapitalization: TextCapitalization.words,
                                ),
                                const SizedBox(height: 16),

                                // 5. Angkatan
                                AccountTextField(
                                  controller: _batchController,
                                  hintText: 'Angkatan',
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(4),
                                  ],
                                  validator: (value) {
                                    final text = value?.trim() ?? '';
                                    if (text.isEmpty) return null;
                                    if (text.length != 4) {
                                      return 'Angkatan harus 4 digit tahun (contoh: 2022)';
                                    }
                                    final year = int.tryParse(text);
                                    final currentYear = DateTime.now().year;
                                    if (year == null ||
                                        year < 2000 ||
                                        year > currentYear) {
                                      return 'Tahun angkatan harus antara 2000 - $currentYear';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),

                                // 6. No telepon
                                AccountTextField(
                                  controller: _phoneController,
                                  hintText: 'Masukkan No tlp',
                                  keyboardType: TextInputType.phone,
                                  textInputAction: TextInputAction.done,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                      RegExp(r'^[+0-9]*$'),
                                    ),
                                  ],
                                  validator: (value) {
                                    final text = value?.trim() ?? '';
                                    if (text.isEmpty) return null;
                                    if (text.length < 9 || text.length > 15) {
                                      return 'Nomor telepon harus 9 - 15 digit';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 28),

                                // Tombol Simpan
                                SizedBox(
                                  width: 122,
                                  height: 42,
                                  child: ElevatedButton(
                                    onPressed: _isSaving ? null : _saveProfile,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      foregroundColor: Colors.white,
                                      elevation: 2,
                                      shadowColor: Colors.black26,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: _isSaving
                                        ? const SizedBox(
                                            width: 18,
                                            height: 18,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Colors.white,
                                            ),
                                          )
                                        : const Text(
                                            'Simpan',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          // Sidebar overlay
          SidebarOverlay(
            controller: _sidebarController,
            onMenuSelected: _onMenuSelected,
          ),
        ],
      ),
    );
  }
}
