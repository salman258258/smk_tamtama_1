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

class TaskDetail extends StatefulWidget {
  const TaskDetail({super.key});

  @override
  State<TaskDetail> createState() => _TaskDetailState();
}

class _TaskDetailState extends State<TaskDetail> {
  late List<Tugas> daftarTugas;
  late Timer _timer;
  final _random = Random();

  final List<String> _daftarMapel = [
    'Fisika',
    'Kimia',
    'Biologi',
    'Ilmu Lingkungan',
    'Astronomi',
    'Geologi',
    'Sains Terapan',
    'Ekosistem',
    'Energi dan Perubahan'
  ];

  final List<String> _daftarKesulitan = ['Pemula', 'Menengah', 'Lanjutan'];

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
            'Tugas IPA ${index + 1} - ${_daftarMapel[_random.nextInt(_daftarMapel.length)]}',
        deskripsi: 'Deskripsi tugas: '
            '${_generateRandomTopic(_random.nextInt(4))}',
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
      0: 'Struktur Sel dan Jaringan',
      1: 'Hukum Newton tentang Gerak',
      2: 'Reaksi Kimia Organik',
      3: 'Sistem Tata Surya',
      4: 'Dampak Pemanasan Global'
    };
    return topics[type] ?? 'Topik IPA Umum';
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
        backgroundColor: Colors.teal[800],
        title: const Text(
          'Tugas IPA',
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
                      color: Colors.green,
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
      case 'Pemula':
        color = Colors.green;
        break;
      case 'Menengah':
        color = Colors.orange;
        break;
      case 'Lanjutan':
        color = Colors.red;
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
    final color = selesai ? Colors.green : Colors.red;

    return Row(
      children: [
        Icon(
          selesai ? Icons.science : Icons.science_outlined,
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
              Icons.science,
              color: Colors.teal[800],
              size: 18,
            ),
            label: Text(
              'Eksperimen',
              style: TextStyle(
                color: Colors.teal[800],
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
              backgroundColor: Colors.teal[800],
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
