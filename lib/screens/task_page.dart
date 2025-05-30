import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Tugas {
  final String waktu;
  final String mataPelajaran;
  final String deskripsi;
  bool selesai;

  Tugas({
    required this.waktu,
    required this.mataPelajaran,
    required this.deskripsi,
    this.selesai = false,
  });
}

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _HalamanTugasState();
}

class _HalamanTugasState extends State<TaskPage> {
  final Random _acak = Random();
  DateTime? _tanggalTerpilih;
  final DateTime _tanggalSekarang = DateTime.now();
  final DateFormat _formatHari = DateFormat('E', 'id_ID');
  final DateFormat _formatTanggal = DateFormat('d');

  final List<String> _daftarMapel = [
    'Matematika Teknik',
    'Pemrograman Berorientasi Objek',
    'Jaringan Dasar',
    'Kewirausahaan',
    'Basis Data',
    'PKK (Praktik Kerja Lapangan)',
    'Sistem Operasi',
    'PPKn',
    'Bahasa Inggris Teknik'
  ];

  final List<String> _daftarTugas = [
    'Kerjakan soal trigonometri lanjutan',
    'Buat program CRUD dengan OOP',
    'Lakukan konfigurasi router Cisco',
    'Analisis studi kasus bisnis',
    'Desain database untuk sistem inventori',
    'Presentasi laporan PKL',
    'Instalasi dual-boot Windows-Linux',
    'Kerjakan soal hukum ketenagakerjaan',
    'Terjemahkan manual teknis'
  ];

  List<Tugas> _generateTugasAcak(DateTime tanggal) {
    return List.generate(_acak.nextInt(4), (index) {
      final jam = 7 + _acak.nextInt(9);
      final menit = _acak.nextInt(4) * 15;

      return Tugas(
        waktu: DateFormat('HH:mm').format(
            DateTime(tanggal.year, tanggal.month, tanggal.day, jam, menit)),
        mataPelajaran: _daftarMapel[_acak.nextInt(_daftarMapel.length)],
        deskripsi: _daftarTugas[_acak.nextInt(_daftarTugas.length)],
      );
    });
  }

  bool _isWeekend(DateTime tanggal) =>
      tanggal.weekday == DateTime.saturday ||
      tanggal.weekday == DateTime.sunday;

  List<DateTime> _getDaftarMinggu() {
    final DateTime sekarang = DateTime.now();
    DateTime senin = sekarang.subtract(Duration(days: sekarang.weekday - 1));
    return List.generate(7, (index) => senin.add(Duration(days: index)));
  }

  Widget _buildHari(DateTime tanggal) {
    final bool terpilih = _tanggalTerpilih != null &&
        DateUtils.isSameDay(_tanggalTerpilih, tanggal);
    final bool hariIni = DateUtils.isSameDay(_tanggalSekarang, tanggal);
    final bool weekend = _isWeekend(tanggal);

    return Container(
      constraints: const BoxConstraints(maxWidth: 80),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: InkWell(
        onTap: () => setState(() => _tanggalTerpilih = tanggal),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: terpilih ? Colors.green[50]! : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _formatHari.format(tanggal).toUpperCase(),
                style: TextStyle(
                  color: weekend ? Colors.red : Colors.grey[700]!,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 8),
              CircleAvatar(
                backgroundColor: terpilih
                    ? Colors.green
                    : weekend
                        ? Colors.red[100]!
                        : Colors.grey[200]!,
                radius: 16,
                child: Text(
                  _formatTanggal.format(tanggal),
                  style: TextStyle(
                    color: terpilih
                        ? Colors.white
                        : weekend
                            ? Colors.red
                            : Colors.grey[800]!,
                    fontWeight: hariIni ? FontWeight.bold : FontWeight.normal,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final daftarMinggu = _getDaftarMinggu();
    final tanggalDipilih = _tanggalTerpilih ?? _tanggalSekarang;
    final List<Tugas> tugas = _generateTugasAcak(tanggalDipilih);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Pekerjaan Rumah',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:
                    daftarMinggu.map((tanggal) => _buildHari(tanggal)).toList(),
              ),
            ),
          ),
          Expanded(
            child: _isWeekend(tanggalDipilih)
                ? _TampilanLibur()
                : _DaftarTugas(
                    tugas: tugas,
                    onToggle: (index) {
                      setState(() {
                        tugas[index].selesai = !tugas[index].selesai;
                      });
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _TampilanLibur extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.school, size: 50, color: Colors.green[300]!),
          const SizedBox(height: 20),
          Text('Hari Libur Sekolah',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600]!)),
          const SizedBox(height: 8),
          Text('Tidak ada jadwal pembelajaran',
              style: TextStyle(color: Colors.grey[500]!)),
        ],
      ),
    );
  }
}

class _DaftarTugas extends StatelessWidget {
  final List<Tugas> tugas;
  final Function(int) onToggle;

  const _DaftarTugas({required this.tugas, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return tugas.isEmpty
        ? Center(
            child: Text('Tidak ada jadwal hari ini',
                style: TextStyle(color: Colors.grey[500]!)))
        : ListView.separated(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: tugas.length,
            separatorBuilder: (context, index) =>
                Divider(color: Colors.grey[200]!, height: 1),
            itemBuilder: (context, index) {
              final task = tugas[index];
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 3,
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: Checkbox(
                    value: task.selesai,
                    onChanged: (v) => onToggle(index),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                    fillColor: MaterialStateProperty.resolveWith<Color>(
                        (states) =>
                            task.selesai ? Colors.green : Colors.grey[300]!),
                  ),
                  title: Text(
                    task.mataPelajaran,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      decoration:
                          task.selesai ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(task.deskripsi,
                          style: TextStyle(color: Colors.grey[600]!)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.access_time,
                              size: 16, color: Colors.green[300]!),
                          const SizedBox(width: 4),
                          Text(task.waktu,
                              style: TextStyle(
                                  color: Colors.green[700]!,
                                  fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }
}
