import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smk_tamtama_1/screens/jadwal.dart';
import 'package:smk_tamtama_1/screens/nilai_page.dart';

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
    'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'
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
    User? user = FirebaseAuth.instance.currentUser;
    String username = user?.email?.split('@')[0] ?? 'Guest';
    return SliverAppBar(
      automaticallyImplyLeading: false,
      pinned: true,
      expandedHeight: 80,
      elevation: 0,
      shadowColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(57, 128, 49, 1.0),
                Color.fromRGBO(34, 72, 32, 1.0),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, bottom: 16.0, right: 16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const CircleAvatar(
                  radius: 18,
                  backgroundImage: AssetImage('assets/images/rapli.png'),
                ),
                const SizedBox(width: 12),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      username,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '2211104056',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Icon(Icons.notifications, color: Colors.yellow, size: 24),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
    );
  }

  Widget _buildBodyContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        _buildScheduleTodayCard(),
        const SizedBox(height: 20),
        const SizedBox(height: 20),
        _buildFeatureSection(),
        const SizedBox(height: 30),
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
          'Jadwal Hari Ini',
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


  Widget _buildJadwalCard(String title, String waktu, String pengajar, Image image) {
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
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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

  Widget _buildFeatureSection() {
    List<Map<String, dynamic>> features = [
      {'icon': 'assets/icons/book.png', 'label': 'Buku', 'screen': null},
      {'icon': 'assets/icons/grade.png', 'label': 'Nilai', 'screen': () => const NilaiScreen()},
      {'icon': 'assets/icons/report.png', 'label': 'Laporan', 'screen': null},
      {'icon': 'assets/icons/book.png', 'label': 'Buku', 'screen': null},
      {'icon': 'assets/icons/book_1.png', 'label': 'Jadwal', 'screen': () => const JadwalScreen()},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('FITUR APLIKASI', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          GridView.builder(
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
                child: _buildFeatureIcon(features[index]['icon'], features[index]['label']),
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
            boxShadow: const [
              BoxShadow(color: Colors.black12, blurRadius: 3, spreadRadius: 0.5),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Image.asset(assetPath),
          ),
        ),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildNewsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('BERITA', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildNewsCard(),
                const SizedBox(width: 15),
                _buildNewsCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewsCard() {
    return SizedBox(
      width: 350,
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          image: const DecorationImage(
            image: AssetImage('assets/images/news.png'),
            fit: BoxFit.cover,
          ),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 2),
          ],
        ),
      ),
    );
  }
}