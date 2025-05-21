import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class JadwalScreen extends StatefulWidget {
  const JadwalScreen({super.key});

  @override
  _JadwalScreenState createState() => _JadwalScreenState();
}

class _JadwalScreenState extends State<JadwalScreen> {
  String selectedDay = "Senin";
  DateTime baseDate = DateTime(2025, 3, 17); // Senin, 17 Maret 2025

  final List<String> days = ["Senin", "Selasa", "Rabu", "Kamis", "Jumat"];

  List<Map<String, dynamic>> scheduleItems = [];

  late Future<void> _firebaseInitialization;

  @override
  void initState() {
    super.initState();
    _firebaseInitialization = Firebase.initializeApp();
  }

  Future<void> fetchSchedule() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('jadwal')
          .doc(selectedDay)
          .get();

      if (doc.exists) {
        final data = doc.data();
        final items = data?['items'];

        if (items != null && items is List) {
          setState(() {
            scheduleItems = List<Map<String, dynamic>>.from(items);
          });
        } else {
          print('⚠️ Data items tidak ditemukan atau bukan List');
          setState(() {
            scheduleItems = [];
          });
        }
      } else {
        print('⚠️ Dokumen untuk $selectedDay tidak ditemukan');
        setState(() {
          scheduleItems = [];
        });
      }
    } catch (e) {
      print('❌ Gagal mengambil jadwal: $e');
      setState(() {
        scheduleItems = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _firebaseInitialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return const Scaffold(
            body: Center(child: Text('Error initializing Firebase')),
          );
        } else {
          return _buildMainScreen();
        }
      },
    );
  }

  Widget _buildMainScreen() {
    int dayIndex = days.indexOf(selectedDay);
    String formattedDate = DateFormat('d MMMM yyyy').format(baseDate.add(Duration(days: dayIndex)));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Row(
          children: [
            Text(
              'Jadwal & Presensi',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Spacer(),
            Icon(Icons.history),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Maret 2025',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: days.map((day) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedDay = day;
                        });
                        fetchSchedule(); // Fetch jadwal baru
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedDay == day ? const Color(0xFF224820) : Colors.white,
                        foregroundColor: selectedDay == day ? Colors.white : const Color(0xFF224820),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(color: Color(0xFF224820)),
                        ),
                      ),
                      child: Text(day),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "$selectedDay,",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              formattedDate,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: scheduleItems.isEmpty
                  ? const Center(child: Text('Tidak ada jadwal'))
                  : ListView(
                      children: scheduleItems.map((item) {
                        return _buildJadwalCard(
                          item["title"] ?? '',
                          item["waktu"] ?? '',
                          item["pengajar"] ?? '',
                          Image.asset('assets/images/tamtama_logo.png'),
                        );
                      }).toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJadwalCard(String title, String waktu, String pengajar, Image image) {
    return Container(
      width: double.infinity,
      height: 130,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border(
          left: BorderSide(color: Colors.green,width: 3)
        ),
        boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        offset: Offset(0, 4),
        blurRadius: 6,        // Efek blur
        spreadRadius: 0,      // Tidak menyebar ke sisi lain
      ),
    ],
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.green.withOpacity(0.3),
        //     blurRadius: 5,
        //     spreadRadius: 1,
        //     offset: const Offset(-5, 0),
        //   ),
        // ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 5),
              SizedBox(
                width: 25,
                height: 25,
                child: Opacity(
                  opacity: 0.4,
                  child: ClipOval(child: image),
                ),
              ),
            ],
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Text('Waktu', style: TextStyle(fontSize: 12)),
                  SizedBox(width: 55),
                  Text('Pengajar', style: TextStyle(fontSize: 12)),
                ],
              ),
              Row(
                children: [
                  Text(
                    waktu,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Text(
                      pengajar,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}