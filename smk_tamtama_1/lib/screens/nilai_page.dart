import 'package:flutter/material.dart';

class NilaiScreen extends StatelessWidget {
  const NilaiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Nilai Siswa',
          style: TextStyle(fontSize: 18,
           fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
         color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Periode Semester',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            SizedBox(height: 16),
            SemesterCard(year: "2025", semester: "Semester 2"),
            SizedBox(height: 12),
            SemesterCard(year: "2025", semester: "Semester 1"),
          ],
        ),
      ),
    );
  }
}

class SemesterCard extends StatelessWidget {
  final String year;
  final String semester;

  const SemesterCard({super.key, required this.year, required this.semester});

  @override
  Widget build(BuildContext context) {
    
    return GestureDetector(
      onTap: () => _showNilaiPopup(context),
      child: Card(
        color: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 2,
              height: 60,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  year,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                Text(
                  semester,
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showNilaiPopup(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent, // buat background sheet jadi transparan supaya borderRadius kelihatan
    builder: (context) {
      return ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        child: DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.8,
          minChildSize: 0.5,
          builder: (context, scrollController) {
            return Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    year,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Text(
                        semester,
                        style: const TextStyle(fontSize: 12),
                      ),
                      const Spacer(),
                      const Text('Rata-rata Nilai 89.9'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      children: const [
                        NilaiTile(mapel: "Ilmu Pengetahuan Alam", nilai: "90"),
                        NilaiTile(mapel: "Ilmu Pengetahuan Sosial", nilai: "89"),
                        NilaiTile(mapel: "Bahasa Indonesia", nilai: "88"),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    },
  );
}

}

class NilaiTile extends StatelessWidget {
  final String mapel;
  final String nilai;

  const NilaiTile({super.key, required this.mapel, required this.nilai});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        title: Text(mapel, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        trailing: Text(nilai, style: const TextStyle(fontSize: 16, color: Colors.green)),
      ),
    );
  }
}