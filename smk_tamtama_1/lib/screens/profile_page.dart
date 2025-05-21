import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProfilePage(),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Kartu Profil
          _buildProfileCard(),
          const SizedBox(height: 20),
          // Daftar Menu
          Expanded(
            child: ListView(
              children: [
                _buildMenuItem(Icons.credit_card, "Kartu Tanda Siswa"),
                _buildMenuItem(Icons.person_outline, "Ubah Role Pengguna"),
                _buildMenuItem(Icons.settings, "Pengaturan"),
                const SizedBox(height: 70),
                _buildMenuItem(Icons.logout, "Logout", isLogout: true),
              ],
            ),
          ),
          // Bottom Navigation
        ],
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.green, Colors.black],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          // Foto Profil
          Container(
            width: 60,
            height: 80,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/rapli.png'),
                fit: BoxFit.cover,
              ),
              shape: BoxShape.circle,
              color: Colors.white, // Tempat foto profil
            ),
          ),
          const SizedBox(width: 10),
          // Nama dan NIM
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            
              Text(
                "Rafli Fauzan Rauf",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Text(
                "2211104050",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, {bool isLogout = false}) {
  return InkWell( // Menggunakan InkWell agar memberikan efek visual saat disentuh
    onTap: () {
      if (isLogout) {
        // Navigasi ke LoginPage menggunakan Get.offAllNamed
        Get.offAllNamed('/login');
        print('Logout tapped! Navigating to Login Page.');
      } else {
        // Tambahkan logika untuk item menu lainnya di sini jika diperlukan
        print('Menu item $title tapped');
        // Contoh navigasi untuk item lain (jika diperlukan)
        // Get.toNamed('/other_page');
      }
    },
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: isLogout ? Colors.red : Colors.black),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: isLogout ? Colors.red : Colors.black,
                fontSize: 14,
              ),
            ),
          ),
          Icon(Icons.arrow_forward_ios,
              size: 16, color: isLogout ? Colors.red : Colors.black),
        ],
      ),
    ),
  );
}
  }