import 'package:flutter/material.dart';
import '../screens/home/home_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/profile/profile_screen.dart';

class AppRoutes {
  AppRoutes._();

  static const String home = '/';
  static const String login = '/login';
  static const String profile = '/profile';

  static Map<String, WidgetBuilder> get routes => {
        home: (_) => const HomeScreen(),
        login: (_) => const LoginScreen(),
        profile: (_) => const ProfileScreen(),
      };
}
