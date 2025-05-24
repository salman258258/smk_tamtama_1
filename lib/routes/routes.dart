import 'package:get/get.dart';
import 'package:smk_tamtama_1/screens/login_page.dart';
import 'package:smk_tamtama_1/screens/profile_page.dart';
import 'package:smk_tamtama_1/screens/scan_page.dart';
import 'package:smk_tamtama_1/widgets/main_page.dart';


class AppRoutes {
  static const String login = '/';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String scan = '/scan';

  static final routes = [
    GetPage(name: login, page: () => const LoginPage()),
    GetPage(name: home, page: () => const MainScreen()),
    GetPage(name: profile, page: () => const ProfilePage()),
    GetPage(name: scan, page: () => const ScanPage()),
  ];
}