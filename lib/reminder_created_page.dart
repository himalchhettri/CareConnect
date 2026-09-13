import 'package:flutter/material.dart';
import 'app_data.dart';
import 'home_page.dart';

class ReminderCreatedPage extends StatelessWidget {
  final MedicationReminder reminder;
  const ReminderCreatedPage({super.key, required this.reminder});

  static const Color careBlue = Color(0xFF22A9F0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0, centerTitle: true, title: const Text('Reminder Created', style: TextStyle(color: Colors.black, fontSize: 15))),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
          child: Column(children: [
            const Spacer(),
            const CircleAvatar(radius: 38, backgroundColor: Color(0xFFEAF6FD), child: Icon(Icons.check, size: 42, color: careBlue)),
            const SizedBox(height: 20),
            const Text('Reminder saved successfully', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text('${reminder.medicineName} • ${reminder.dosage}', textAlign: TextAlign.center),
            const SizedBox(height: 25),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(color: const Color(0xFFEAF6FD), borderRadius: BorderRadius.circular(10)),
              child: Column(children: [
                const Icon(Icons.access_time, color: careBlue, size: 25),
                const SizedBox(height: 8),
                Text(reminder.time.format(context), style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                Text(reminder.days.join(', '), style: const TextStyle(fontSize: 11)),
              ]),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                onPressed: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const HomePage()), (route) => false),
                style: ElevatedButton.styleFrom(backgroundColor: careBlue, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                child: const Text('Back To Home'),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
