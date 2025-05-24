import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:smk_tamtama_1/screens/home_page.dart';
import 'package:smk_tamtama_1/screens/profile_page.dart';
import 'package:smk_tamtama_1/screens/qr_code.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late PersistentTabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
  }

  List<Widget> _buildScreens() {
    return [
      const HomePage(),
      const QRScannerScreen(),
      const ProfilePage(),
    ];
  }

 List<PersistentBottomNavBarItem> _navBarsItems() {
  return [
    PersistentBottomNavBarItem(
  icon: SizedBox(
    width: 27, // Atur ukuran sesuai kebutuhan
    height: 27,
    child: Image.asset('assets/icons/home.png'),
  ),
),
    PersistentBottomNavBarItem(
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: Colors.green,
          shape: BoxShape.circle,
        ),
        child: Image.asset('assets/icons/barcode.png'),
      ),
      activeColorPrimary: Colors.green,
      inactiveColorPrimary: Colors.grey,
      textStyle: const TextStyle(fontSize: 12, height: 2), // 🔹 Jarak teks lebih dekat
      iconSize: 24,
    ),
   PersistentBottomNavBarItem(
  icon: SizedBox(
    width: 27, // Atur ukuran sesuai kebutuhan
    height: 27,
    child: Image.asset('assets/icons/user.png'),
  ),
  )
  ];
}
  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      navBarStyle: NavBarStyle.style15,
      backgroundColor: Colors.grey[200] ?? Colors.grey,
      navBarHeight:50.0,
    );
  }
}