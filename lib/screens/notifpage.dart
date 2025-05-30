import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationModel {
  final String subject;
  final String title;
  final String message;
  final DateTime timestamp;
  final String course;
  bool isRead;

  NotificationModel({
    required this.subject,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.course,
    this.isRead = false,
  });
}

class NotifPage extends StatefulWidget {
  const NotifPage({super.key});

  @override
  State<NotifPage> createState() => _NotifPageState();
}

class _NotifPageState extends State<NotifPage> {
  final List<NotificationModel> notifications = [
    NotificationModel(
      subject: 'IPA',
      title: 'Materi Baru: Struktur Sel',
      message:
          'Slide presentasi bab 5 tentang struktur sel tumbuhan sudah tersedia',
      timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
      course: 'Biologi Sel',
    ),
    NotificationModel(
      subject: 'IPS',
      title: 'Tenggat Pengumpulan Makalah',
      message:
          'Makalah tentang dampak globalisasi harus dikumpulkan sebelum Jumat',
      timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
      course: 'Sosiologi Modern',
    ),
    NotificationModel(
      subject: 'Bahasa Indonesia',
      title: 'Hasil Ujian Praktek Membaca',
      message: 'Nilai ujian membaca puisi sudah bisa diakses di portal',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      course: 'Apresiasi Sastra',
    ),
    NotificationModel(
      subject: 'IPA',
      title: 'Praktikum Kimia Dasar',
      message: 'Siapkan alat praktikum untuk percobaan reaksi oksidasi',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      course: 'Kimia Anorganik',
    ),
  ];

  int get unreadCount => notifications.where((n) => !n.isRead).length;

  void markAllAsRead() {
    setState(() {
      for (var notification in notifications) {
        notification.isRead = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Notifikasi Mata Pelajaran',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: [
                Text(
                  'Belum dibaca: $unreadCount',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 16),
                TextButton(
                  onPressed: markAllAsRead,
                  child: const Text(
                    'Tandai Sudah Dibaca',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Container(
        color: Colors.white, // 1. Set background putih untuk area utama
        child: ListView.separated(
          padding: const EdgeInsets.all(16),
          physics:
              const BouncingScrollPhysics(), // 2. Efek scroll lebih natural
          itemCount: notifications.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final notif = notifications[index];
            return _buildNotificationCard(notif);
          },
        ),
      ),
    );
  }

  Widget _buildNotificationCard(NotificationModel notif) {
    Colors.white;
    final timeFormat = DateFormat('HH:mm');
    final dateFormat = DateFormat('dd MMM yyyy');

    return Card(
      color: Colors.white,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          // 1. Tambahkan border side di Card
          color: Colors.grey[300]!, // Warna abu-abu muda
          width: 0.8,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.grey[300]!, // 2. Ganti warna border di Container
            width: 0.5,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildSubjectIcon(notif.subject),
                  const SizedBox(width: 12),
                  Text(
                    notif.subject,
                    style: TextStyle(
                      color: _getSubjectColor(notif.subject),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const Spacer(),
                  if (!notif.isRead)
                    const Icon(Icons.brightness_1,
                        size: 12, color: Colors.green),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                notif.title,
                style: TextStyle(
                  fontWeight:
                      notif.isRead ? FontWeight.normal : FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                notif.message,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.access_time, size: 16, color: Colors.grey[500]),
                  const SizedBox(width: 4),
                  Text(
                    '${timeFormat.format(notif.timestamp)}, ${dateFormat.format(notif.timestamp)}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    notif.course,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getSubjectColor(String subject) {
    switch (subject) {
      case 'IPA':
        return Colors.green;
      case 'IPS':
        return Colors.orange;
      case 'Bahasa Indonesia':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  Widget _buildSubjectIcon(String subject) {
    IconData icon;
    switch (subject) {
      case 'IPA':
        icon = Icons.science;
        break;
      case 'IPS':
        icon = Icons.public;
        break;
      case 'Bahasa Indonesia':
        icon = Icons.menu_book;
        break;
      default:
        icon = Icons.notifications;
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: _getSubjectColor(subject).withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 20, color: _getSubjectColor(subject)),
    );
  }
}
