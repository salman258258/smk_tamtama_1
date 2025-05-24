import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math';

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

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool allowFaceId = true;
  bool showCoins = true;
  bool incognitoMode = false;

String generateRandomIndoPhoneNumber() {
  final random = Random();
  String number = '+62';
  for (int i = 0; i < 10; i++) {
    number += random.nextInt(10).toString();
  }
  return number;
}
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email ?? 'Belum login';
    final username = email.split('@')[0];
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Profil',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          _buildHeader(),
          const SizedBox(height: 20),
          _buildSectionTitle("Personal info"),
          _buildInfoTile(Icons.person, "Nama", username),
          _buildInfoTile(Icons.phone, "Nomor Telepon", generateRandomIndoPhoneNumber()),
          _buildInfoTile(Icons.email, "Alamat Email", email),
          const SizedBox(height: 20),
          _buildSectionTitle("Settings"),
          _buildSwitchTile("Allow Face ID", allowFaceId, (val) {
            setState(() => allowFaceId = val);
          }),
          _buildSwitchTile("Showing Coins", showCoins, (val) {
            setState(() => showCoins = val);
          }),
          _buildSwitchTile("Incognito mode", incognitoMode, (val) {
            setState(() => incognitoMode = val);
          }),
          _buildInfoTile(Icons.lock, "Code to enter into the app", "Change entrance code"),
          _buildInfoTile(Icons.language, "Language", "English"),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        const CircleAvatar(
          radius: 45,
          backgroundImage: AssetImage('assets/images/rapli.png'),
        ),
        const SizedBox(height: 10),
        InkWell(
          onTap: () {
          },
          child: const Icon(Icons.edit, size: 18, color: Colors.grey),
        )
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildInfoTile(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(title, style: const TextStyle(fontSize: 14)),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        print('Tapped on $title');
      },
    );
  }

  Widget _buildSwitchTile(String title, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      title: Text(title, style: const TextStyle(fontSize: 14)),
      value: value,
      onChanged: onChanged,
      activeColor: Colors.green,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
    );
  }
}