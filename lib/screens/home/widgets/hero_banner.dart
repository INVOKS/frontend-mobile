import 'package:flutter/material.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/theme/app_colors.dart';

class HeroBanner extends StatelessWidget {
  const HeroBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 205,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            AppAssets.heroBanner,
            fit: BoxFit.cover,
            semanticLabel: 'Gedung Vokasi Universitas Brawijaya',
            errorBuilder: (context, error, stackTrace) => const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF55758A), Color(0xFF183B52)],
                ),
              ),
              child: Icon(
                Icons.account_balance_outlined,
                size: 80,
                color: Color(0x55FFFFFF),
              ),
            ),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0x99000000), Color(0x66000000)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'SISTEM PUSAT\nINVENTARIS VOKASI',
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: TextStyle(
                    color: AppColors.textOnPrimary,
                    fontSize: 20,
                    height: 1.2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'UNIVERSITAS BRAWIJAYA',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textOnPrimary,
                    fontSize: 9,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w500,
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
