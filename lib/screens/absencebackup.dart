import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AbsenceBackup extends StatefulWidget {
  const AbsenceBackup({super.key});

  @override
  State<AbsenceBackup> createState() => _AbsenceBackupState();
}

class _AbsenceBackupState extends State<AbsenceBackup> {
  late List<DateTime> attendanceDates;
  late Timer _timer;
  late List<String> attendanceStatus;
  final _random = Random();
  final _statusOptions = ['Hadir', 'Izin', 'Sakit', 'Alpha'];

  @override
  void initState() {
    super.initState();

    // Generate 7 random dates in 2025
    attendanceDates = _generateRandomDates(2025, 7);

    // Generate random status
    attendanceStatus = List.generate(
      7,
      (index) => _statusOptions[_random.nextInt(_statusOptions.length)],
    );

    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (mounted) setState(() {});
    });
  }

  List<DateTime> _generateRandomDates(int year, int count) {
    final startDate = DateTime(year, 1, 1);
    final endDate = DateTime(year, 12, 31);
    final daysDifference = endDate.difference(startDate).inDays;

    final dates = <DateTime>{};
    while (dates.length < count) {
      final randomDay = _random.nextInt(daysDifference);
      dates.add(startDate.add(Duration(days: randomDay)));
    }

    // Sort dates and return as list
    return dates.toList()..sort((a, b) => a.compareTo(b));
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Absensi',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: attendanceDates.length,
        separatorBuilder: (context, index) => const Divider(height: 24),
        itemBuilder: (context, index) =>
            _buildAttendanceItem(attendanceDates[index], index),
      ),
    );
  }

  Widget _buildAttendanceItem(DateTime date, int index) {
    // Generate random time between 07:00-09:00 for check-in
    // and 16:00-18:00 for check-out
    final checkIn = TimeOfDay(
      hour: 7 + _random.nextInt(2),
      minute: _random.nextInt(60),
    );

    final checkOut = TimeOfDay(
      hour: 16 + _random.nextInt(2),
      minute: _random.nextInt(60),
    );

    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  DateFormat('d MMM, y', 'id_ID').format(date),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  DateFormat('EEEE', 'id_ID').format(date),
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildStatusIndicator(index),
            const SizedBox(height: 8),
            _buildScheduleRow(checkIn, checkOut),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(int index) {
    const statusColors = {
      'Hadir': Colors.green,
      'Izin': Colors.orange,
      'Sakit': Colors.blue,
      'Alpha': Colors.red,
    };

    final status = attendanceStatus[index];
    final color = statusColors[status]!;

    return Row(
      children: [
        const Icon(Icons.calendar_today, size: 18, color: Colors.grey),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(Icons.circle, color: color, size: 12),
              const SizedBox(width: 8),
              Text(
                status,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildScheduleRow(TimeOfDay checkIn, TimeOfDay checkOut) {
    final checkInStr = checkIn.format(context);
    final checkOutStr = checkOut.format(context);

    return Row(
      children: [
        const Icon(Icons.timer, size: 18, color: Colors.grey),
        const SizedBox(width: 8),
        Text(
          checkInStr,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 16),
        const Text('-', style: TextStyle(fontSize: 14)),
        const SizedBox(width: 16),
        Text(
          checkOutStr,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
