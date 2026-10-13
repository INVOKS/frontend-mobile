import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../widgets/register_header.dart';
import '../widgets/register_form.dart';
import 'register_success_screen.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final height = mq.size.height;
    final topPadding = mq.viewPadding.top;
    // viewInsets.bottom = tinggi keyboard (berubah saat keyboard muncul/hilang)
    // digunakan HANYA untuk padding scroll, bukan untuk memindahkan layout
    final keyboardHeight = mq.viewInsets.bottom;

    return Scaffold(
      resizeToAvoidBottomInset: false, // background tidak bergerak
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // ─── Layer 1: Background biru — FIXED, tidak pernah bergerak ───
          Container(
            height: height * 0.5,
            width: double.infinity,
            color: AppColors.primary,
          ),

          // ─── Layer 2: Konten ───
          Padding(
            padding: EdgeInsets.only(
              top: topPadding,
              bottom: keyboardHeight,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Tombol back
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon:
                          const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ),
                ),

                // Header (judul + subtitle) — FIXED
                const RegisterHeader(),
                const SizedBox(height: 32),

                // Form: background putih FIXED, isi di dalam bisa di-scroll
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                    child: RegisterForm(
                      onLoginTap: () {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        }
                      },
                      onRegisterSuccess: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RegisterSuccessScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
