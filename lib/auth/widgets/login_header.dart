import 'package:flutter/material.dart';
import '../../constants/app_assets.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(AppAssets.logo, height: 110),
        const SizedBox(height: 16),
        const Text(
          'Masuk ke Akun\nAnda',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Masukkan email dan kata sandi anda',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
      ],
    );
  }
}