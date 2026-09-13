import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'appointments_page.dart';
import 'home_page.dart';

class BookingConfirmedPage extends StatelessWidget {
  final String doctorName;
  final String date;
  final String time;

  const BookingConfirmedPage({super.key, required this.doctorName, required this.date, required this.time});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Column(children: [
                Container(
                  width: 92,
                  height: 92,
                  decoration: const BoxDecoration(color: Color(0xFFDCFCE7), shape: BoxShape.circle),
                  child: const Icon(Icons.check_rounded, color: Color(0xFF16A34A), size: 50),
                ),
                const SizedBox(height: 24),
                const Text('Appointment confirmed', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                const Text('Your appointment has been added to CareConnect.', textAlign: TextAlign.center, style: TextStyle(color: AppTheme.textSecondary)),
                const SizedBox(height: 26),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(children: [
                      _summary(Icons.person_outline_rounded, 'Doctor', doctorName),
                      const Divider(height: 26),
                      _summary(Icons.calendar_today_outlined, 'Date', date),
                      const Divider(height: 26),
                      _summary(Icons.schedule_rounded, 'Time', time),
                    ]),
                  ),
                ),
                const SizedBox(height: 26),
                ElevatedButton(
                  onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AppointmentsPage())),
                  child: const Text('View Appointment'),
                ),
                const SizedBox(height: 10),
                OutlinedButton(
                  onPressed: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const HomePage()), (route) => false),
                  child: const Text('Back to Home'),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  Widget _summary(IconData icon, String label, String value) {
    return Row(children: [
      Container(width: 40, height: 40, decoration: BoxDecoration(color: AppTheme.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: AppTheme.primary, size: 20)),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
      ])),
    ]);
  }
}
