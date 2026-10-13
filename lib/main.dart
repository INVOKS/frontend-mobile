import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'screens/home/home_screen.dart';

import 'core/theme/app_theme.dart';
import 'screens/home/home_screen.dart';

void main() {
<<<<<<< Updated upstream
=======
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

>>>>>>> Stashed changes
  runApp(const InvoksApp());
}

class InvoksApp extends StatelessWidget {
  const InvoksApp({super.key});
<<<<<<< Updated upstream
=======

  static const Color primaryBlue = Color(0xFF005B96);
>>>>>>> Stashed changes

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'INVOKS',
<<<<<<< Updated upstream
      theme: AppTheme.light,
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
=======
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        useMaterial3: false,

        primaryColor: primaryBlue,
        scaffoldBackgroundColor: const Color(0xFFFAFAFA),

        colorScheme: const ColorScheme.light(
          primary: primaryBlue,
          secondary: primaryBlue,
          surface: Colors.white,
        ),

        appBarTheme: const AppBarTheme(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: primaryBlue,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
          ),
        ),
      ),

      initialRoute: '/home',

      routes: {
        '/home': (context) => const HomeScreen(),
      },
>>>>>>> Stashed changes
    );
  }
}