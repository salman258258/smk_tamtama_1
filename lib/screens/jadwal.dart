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
  List<Map<String, dynamic>> scheduleItems = [];
  late Future<void> _firebaseInitialization;

  final Map<String, int> dayNameToIndex = {
    'Senin': DateTime.monday,
    'Selasa': DateTime.tuesday,
    'Rabu': DateTime.wednesday,
    'Kamis': DateTime.thursday,
    'Jumat': DateTime.friday,
  };

  final List<String> days = ["Senin", "Selasa", "Rabu", "Kamis", "Jumat"];

  @override
  void initState() {
    super.initState();
    _firebaseInitialization = Firebase.initializeApp();
    fetchSchedule(); // fetch awal
  }

  DateTime getDateForSelectedDay() {
    DateTime today = DateTime.now();
    int selectedWeekday = dayNameToIndex[selectedDay]!;
    int difference = selectedWeekday - today.weekday;

    if (difference < 0) {
      // Hari yang sudah lewat, ambil minggu berikutnya
      difference += 7;
    }

    return today.add(Duration(days: difference));
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
          setState(() {
            scheduleItems = [];
          });
        }
      } else {
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
    DateTime selectedDate = getDateForSelectedDay();
    String formattedDate = DateFormat('d MMMM yyyy', 'id_ID').format(selectedDate);

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
            Text(
              DateFormat('MMMM yyyy', 'id_ID').format(selectedDate),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 10),
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
                        fetchSchedule();
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
            const SizedBox(height: 5),
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
        border: const Border(
          left: BorderSide(color: Colors.green, width: 3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, 4),
            blurRadius: 6,
          ),
        ],
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
              const SizedBox(width: 10),
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
           Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Waktu', style: TextStyle(fontSize: 12)),
                Text(
                  waktu,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(width: 40),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Pengajar', style: TextStyle(fontSize: 12)),
                  Text(
                    pengajar,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
          )
        ],
      ),
    );
  }
}
