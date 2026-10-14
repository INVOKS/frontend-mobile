import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'auth/screens/login_screen.dart';
import 'core/theme/app_theme.dart';
import 'screens/booking_history/booking_history_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/rooms/rooms_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Color(0xFF005B96),
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const InvoksApp(home: LoginScreen()));
}

class InvoksApp extends StatelessWidget {
  const InvoksApp({super.key, this.home = const HomeScreen()});

  final Widget home;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'INVOKS',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: home,
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/booking-history': (context) => const BookingHistoryScreen(),
        '/rooms': (context) => const RoomsScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}

