import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Tugas {
  final String judul;
  final String deskripsi;
  final DateTime deadline;
  bool selesai;
  final String mataPelajaran;
  final String tingkatKesulitan;

  Tugas({
    required this.judul,
    required this.deskripsi,
    required this.deadline,
    this.selesai = false,
    required this.mataPelajaran,
    required this.tingkatKesulitan,
  });
}

class TaskDetailBahasa extends StatefulWidget {
  const TaskDetailBahasa({super.key});

  @override
  State<TaskDetailBahasa> createState() => _TaskDetailBahasaState();
}

class _TaskDetailBahasaState extends State<TaskDetailBahasa> {
  late List<Tugas> daftarTugas;
  late Timer _timer;
  final _random = Random();

  final List<String> _daftarMapel = [
    'Tata Bahasa',
    'Sastra',
    'Membaca Kritis',
    'Menulis Kreatif',
    'Apresiasi Puisi',
    'Drama',
    'Ejaan',
    'Morfologi',
    'Semantik'
  ];

  final List<String> _daftarKesulitan = ['Dasar', 'Menengah', 'Mahir'];

  @override
  void initState() {
    super.initState();
    daftarTugas = _generateRandomTasks(7);
    _timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (mounted) setState(() {});
    });
  }

  List<Tugas> _generateRandomTasks(int count) {
    return List.generate(count, (index) {
      final deadline = DateTime.now().add(Duration(days: _random.nextInt(7)));

      return Tugas(
        judul:
            'Tugas Bahasa ${index + 1} - ${_daftarMapel[_random.nextInt(_daftarMapel.length)]}',
        deskripsi: 'Deskripsi tugas: '
            '${_generateRandomTopic(_random.nextInt(5))}',
        deadline: deadline,
        selesai: _random.nextBool(),
        mataPelajaran: _daftarMapel[_random.nextInt(_daftarMapel.length)],
        tingkatKesulitan:
            _daftarKesulitan[_random.nextInt(_daftarKesulitan.length)],
      );
    });
  }

  String _generateRandomTopic(int type) {
    const topics = {
      0: 'Analisis Struktur Puisi',
      1: 'Penulisan Cerpen',
      2: 'Penerapan Ejaan yang Disempurnakan',
      3: 'Membuat Sinopsis Novel',
      4: 'Debat Bahasa Indonesia',
      5: 'Analisis Unsur Intrinsik Cerita'
    };
    return topics[type] ?? 'Topik Bahasa Umum';
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[800],
        title: const Text(
          'Tugas Bahasa Indonesia',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: daftarTugas.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) =>
            _buildTaskItem(daftarTugas[index], index),
      ),
    );
  }

  Widget _buildTaskItem(Tugas tugas, int index) {
    final timeLeft = tugas.deadline.difference(DateTime.now());

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    tugas.judul,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.brown,
                    ),
                  ),
                ),
                _buildDifficultyIndicator(tugas.tingkatKesulitan),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              tugas.deskripsi,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 12),
            _buildStatusIndicator(tugas.selesai),
            const SizedBox(height: 12),
            _buildDeadlineRow(tugas.deadline, timeLeft),
            const SizedBox(height: 8),
            _buildActionButtons(index),
          ],
        ),
      ),
    );
  }

  Widget _buildDifficultyIndicator(String tingkat) {
    Color color;
    switch (tingkat) {
      case 'Dasar':
        color = Colors.orange;
        break;
      case 'Menengah':
        color = Colors.deepOrange;
        break;
      case 'Mahir':
        color = Colors.brown;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color),
      ),
      child: Text(
        tingkat,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(bool selesai) {
    final status = selesai ? 'Selesai' : 'Belum Dikerjakan';
    final color = selesai ? Colors.green : Colors.blue;

    return Row(
      children: [
        Icon(
          selesai ? Icons.book : Icons.edit,
          color: color,
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(
          status,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildDeadlineRow(DateTime deadline, Duration timeLeft) {
    return Row(
      children: [
        Icon(Icons.timer, size: 18, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Batas Waktu: ${DateFormat('dd MMM yyyy, HH:mm', 'id_ID').format(deadline)}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
            Text(
              'Sisa Waktu: ${timeLeft.inDays} hari ${timeLeft.inHours.remainder(24)} jam',
              style: TextStyle(
                fontSize: 12,
                color: Colors.red[700],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons(int index) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            icon: Icon(
              Icons.edit,
              color: Colors.brown[800],
              size: 18,
            ),
            label: Text(
              'Edit Naskah',
              style: TextStyle(
                color: Colors.brown[800],
                fontSize: 14,
              ),
            ),
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.check, size: 18, color: Colors.white),
            label: const Text(
              'Tandai Selesai',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
            onPressed: () {
              setState(() {
                daftarTugas[index].selesai = !daftarTugas[index].selesai;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.brown[800],
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
