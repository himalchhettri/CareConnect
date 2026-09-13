import 'package:flutter/material.dart';
import 'app_data.dart';
import 'app_theme.dart';
import 'booking_confirmed_page.dart';

class ConfirmBookingPage extends StatelessWidget {
  final String doctorName;
  final String speciality;
  final String date;
  final String time;
  final String reason;
  final double fee;

  const ConfirmBookingPage({
    super.key,
    required this.doctorName,
    required this.speciality,
    required this.date,
    required this.time,
    required this.reason,
    required this.fee,
  });

  Widget _row(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, size: 19, color: AppTheme.primary),
        const SizedBox(width: 10),
        SizedBox(width: 84, child: Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary))),
        Expanded(child: Text(value, textAlign: TextAlign.right, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700))),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Review Booking')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 30),
        children: [
          const Text('Confirm your appointment', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
          const SizedBox(height: 7),
          const Text('Please check the details before confirming.', style: TextStyle(color: AppTheme.textSecondary)),
          const SizedBox(height: 22),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(children: [
                Row(children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(color: AppTheme.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(15)),
                    child: const Icon(Icons.person_rounded, color: AppTheme.primary),
                  ),
                  const SizedBox(width: 13),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(doctorName, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                    const SizedBox(height: 3),
                    Text(speciality, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                  ])),
                ]),
                const Divider(height: 28),
                _row(Icons.calendar_today_outlined, 'Date', date),
                _row(Icons.schedule_rounded, 'Time', time),
                _row(Icons.medical_information_outlined, 'Reason', reason),
                _row(Icons.payments_outlined, 'Fee', '\$${fee.toStringAsFixed(0)}'),
              ]),
            ),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: const Color(0xFFECFDF5), borderRadius: BorderRadius.circular(14)),
            child: const Row(children: [
              Icon(Icons.verified_user_outlined, color: Color(0xFF059669)),
              SizedBox(width: 10),
              Expanded(child: Text('Your booking details will be shown in My Appointments after confirmation.', style: TextStyle(fontSize: 12, color: Color(0xFF065F46)))),
            ]),
          ),
          const SizedBox(height: 26),
          ElevatedButton(
            onPressed: () {
              AppData.addAppointment(Appointment(
                doctorName: doctorName,
                speciality: speciality,
                date: date,
                time: time,
                reason: reason,
                fee: fee,
              ));
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => BookingConfirmedPage(doctorName: doctorName, date: date, time: time)),
              );
            },
            child: const Text('Confirm Booking'),
          ),
          const SizedBox(height: 10),
          OutlinedButton(onPressed: () => Navigator.pop(context), child: const Text('Go Back')),
        ],
      ),
    );
  }
}
