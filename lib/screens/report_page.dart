import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'subabsence.dart'; // Pastikan file absence.dart ada di direktori yang sama

class ReportPage extends StatelessWidget {
  const ReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Laporan'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('LAPORAN'),
            _buildReportItem(
              title: 'Absensi',
              subtitle: 'Ini adalah cara kamu untuk melihat absensi.',
              onTap: () =>
                  Get.to(() => SubAbsencePage()), // Navigasi menggunakan GetX
            ),
            _buildReportItem(
              title: 'Tugas',
              subtitle: 'Ini adalah cara kamu untuk melihat tugas.',
              onTap: () {}, // Tambahkan logika untuk halaman tugas
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.green,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildReportItem({
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ),
            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
          ),
        ),
      ),
    );
  }
}
