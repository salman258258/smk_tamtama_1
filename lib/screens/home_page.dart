import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smk_tamtama_1/screens/jadwal.dart';
import 'package:smk_tamtama_1/screens/nilai_page.dart';
import 'package:smk_tamtama_1/screens/report_page.dart';
import 'package:smk_tamtama_1/screens/task_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String selectedDay; // declare tapi
  List<String> days = ["Senin", "Selasa", "Rabu", "Kamis", "Jumat"];
  List<Map<String, dynamic>> scheduleItems = [];

  @override
  void initState() {
    super.initState();

    // Ambil hari ini, lalu fetch jadwalnya
    final now = DateTime.now();
    final List<String> days = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu'
    ];
    selectedDay = days[now.weekday - 1]; // weekday: 1=Senin ... 7=Minggu

    fetchSchedule();
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
      print('❌ Error fetching schedule: $e');
      setState(() {
        scheduleItems = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(child: _buildBodyContent()),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    Widget _buildCircleIcon(IconData icon) {
      return Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFFE0E0E0), // Warna abu muda
        ),
        child: Icon(
          icon,
          size: 20,
          color: Colors.black54,
        ),
      );
    }

    User? user = FirebaseAuth.instance.currentUser;
    String username = user?.email?.split('@')[0] ?? 'Guest';
    if (username.isNotEmpty) {
      username = username[0].toUpperCase() + username.substring(1);
    }
    return SliverAppBar(
      automaticallyImplyLeading: false,
      pinned: true,
      backgroundColor: Colors.white,
      expandedHeight: 80,
      elevation: 0,
      shadowColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage('assets/images/rapli.png'),
              ),
              const SizedBox(width: 12),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Good Morning,',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    username, // AMBIL DARI DATABASE
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Row(
                children: [
                  _buildCircleIcon(Icons.notifications_none),
                  const SizedBox(width: 8),
                  _buildCircleIcon(
                      Icons.sync_alt), // bisa kamu ganti sesuai kebutuhan
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBodyContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 0),
        _buildScheduleTodayCard(),
        const SizedBox(height: 20),
        const SizedBox(height: 0),
        _buildFeatureSection(),
        const SizedBox(height: 20),
        _buildNewsSection(),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildScheduleTodayCard() {
    if (scheduleItems.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Center(child: Text("Tidak ada jadwal hari ini.")),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'JADWAL HARI INI',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: scheduleItems.map((item) {
                return _buildJadwalCard(
                  item['title'] ?? '',
                  item['waktu'] ?? '',
                  item['pengajar'] ?? '',
                  Image.asset('assets/images/tamtama_logo.png', height: 20.0),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJadwalCard(
      String title, String waktu, String pengajar, Image image) {
    return Container(
      width: 350,
      height: 150,
      margin: const EdgeInsets.only(right: 15, bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border(
          left: BorderSide(color: Colors.green, width: 3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: Offset(0, 4),
            blurRadius: 6,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 5),
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
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
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
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold),
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

  Widget _buildFeatureSection() {
    List<Map<String, dynamic>> features = [
      {
        'icon': 'assets/icons/book.png',
        'label': 'PR',
        'screen': () => const TaskPage()
      },
      {
        'icon': 'assets/icons/grade.png',
        'label': 'Nilai',
        'screen': () => const NilaiScreen()
      },
      {
        'icon': 'assets/icons/report.png',
        'label': 'Laporan',
        'screen': () => const ReportPage()
      },
      {
        'icon': 'assets/icons/book_1.png',
        'label': 'Jadwal',
        'screen': () => const JadwalScreen()
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('FITUR',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          GridView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: features.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  if (features[index]['screen'] != null) {
                    Get.to(features[index]['screen']);
                  }
                },
                child: _buildFeatureIcon(
                    features[index]['icon'], features[index]['label']),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureIcon(String assetPath, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                offset: Offset(0, 4),
                blurRadius: 6,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Image.asset(assetPath),
          ),
        ),
        const SizedBox(height: 5),
        Text(label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildNewsSection() {
    List<Map<String, String>> tugasList = [
      {
        'judul': 'PR.1 - PPT RUMUS ROY SURYO',
        'mapel': 'ILMU PENGETAHUAN ALAM',
        'deadline': 'Minggu, 25 Mei 2025 - 23:59'
      },
      {
        'judul': 'PR.2 - VIDEO EKOSISTEM',
        'mapel': 'ILMU PENGETAHUAN SOSIAL',
        'deadline': 'Senin, 26 Mei 2025 - 12:00'
      },
      {
        'judul': 'PR.3 - LATIHAN SOAL PTS',
        'mapel': 'MATEMATIKA',
        'deadline': 'Selasa, 27 Mei 2025 - 09:00'
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('TIMELINE',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: tugasList.length,
              itemBuilder: (context, index) {
                final tugas = tugasList[index];
                return Container(
                  margin: EdgeInsets.only(right: 15, left: index == 0 ? 5 : 0),
                  width: 280, // Lebar card
                  child: _buildTugasCard(tugas['judul'] ?? '',
                      tugas['mapel'] ?? '', tugas['deadline'] ?? ''),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTugasCard(String judul, String mapel, String deadline) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border(
          left: BorderSide(color: Colors.red, width: 3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: Offset(0, 4),
            blurRadius: 6,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(judul,
              style:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Text(mapel,
              style: const TextStyle(fontSize: 12, color: Colors.black87)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(deadline,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600])),
            ],
          )
        ],
      ),
    );
  }
}

//   Widget _buildNewsCard() {
//     return SizedBox(
//       width: 350,
//       child: Container(
//         height: 180,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(15),
//           image: const DecorationImage(
//             image: AssetImage('assets/images/news.png'),
//             fit: BoxFit.cover,
//           ),
//           boxShadow: const [
//             BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 2),
//           ],
//         ),
//       ),
//     );
//   }
// }
