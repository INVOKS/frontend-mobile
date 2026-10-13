import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../widgets/login_header.dart';
import '../widgets/login_form.dart';
import 'register_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final height = mq.size.height;
    final topPadding = mq.viewPadding.top;
    // keyboard height: digunakan untuk menyempitkan viewport scroll,
    // bukan untuk menggeser background
    final keyboardHeight = mq.viewInsets.bottom;

    return Scaffold(
      resizeToAvoidBottomInset: false, // background TIDAK bergerak
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // ── Layer 1: Background biru — benar-benar fixed ──
          Container(
            height: height * 0.5,
            width: double.infinity,
            color: AppColors.primary,
          ),
          // konten — pakai Padding manual bukan SafeArea agar tidak bereaksi ke keyboard
          Padding(
            padding: EdgeInsets.only(
              top: topPadding,
              bottom: keyboardHeight,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {},
                    ),
                  ),
                ),
                const LoginHeader(),
                const SizedBox(height: 32),
                // form bisa di-scroll di dalamnya, tapi container putih tidak bergerak
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                    child: LoginForm(
                      // LoginScreen yang bertanggung jawab navigasi ke RegisterScreen
                      onRegisterTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RegisterScreen(),
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