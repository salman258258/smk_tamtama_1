import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';


class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: PersistentTabController(initialIndex: selectedIndex),
      screens: const [], // Tidak diperlukan karena halaman dikelola di MainScreen
      items: [
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.home),
          activeColorPrimary: Colors.green,
          inactiveColorPrimary: Colors.grey,
        ),
        PersistentBottomNavBarItem(
          icon: Image.asset('assets/icons/barcode.png'),
          activeColorPrimary: Colors.white,
          inactiveColorPrimary: Colors.grey,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.person),
          activeColorPrimary: Colors.green,
          inactiveColorPrimary: Colors.grey,
        ),
      ],
      onItemSelected: onItemTapped,
      navBarStyle: NavBarStyle.style15, // ✅ Menggunakan style15
      backgroundColor: Colors.green,
      
    );
  }
}