import 'package:flutter/material.dart';
import 'app_data.dart';
import 'app_theme.dart';
import 'confirm_booking_page.dart';

class BookAppointmentPage extends StatefulWidget {
  final Doctor doctor;
  const BookAppointmentPage({super.key, required this.doctor});

  @override
  State<BookAppointmentPage> createState() => _BookAppointmentPageState();
}

class _BookAppointmentPageState extends State<BookAppointmentPage> {
  late DateTime selectedDate;
  String selectedTime = '10:30 AM';
  String selectedReason = 'General Consultation';

  final List<String> times = ['09:00 AM', '09:30 AM', '10:00 AM', '10:30 AM', '11:00 AM', '11:30 AM', '02:00 PM', '02:30 PM'];
  final List<String> reasons = ['General Consultation', 'Follow-up', 'Prescription', 'Health Check'];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    selectedDate = DateTime(now.year, now.month, now.day);
  }

  String _formatDate(DateTime date) {
    const months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  Future<void> _selectDate() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: today,
      lastDate: DateTime(today.year + 1, today.month, today.day),
    );
    if (picked != null) setState(() => selectedDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Book Appointment')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 6, 18, 30),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(color: AppTheme.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(15)),
                  child: const Icon(Icons.person_rounded, color: AppTheme.primary),
                ),
                const SizedBox(width: 13),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(widget.doctor.name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                  const SizedBox(height: 3),
                  Text(widget.doctor.speciality, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                ])),
                Text('\$${widget.doctor.fee.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
              ]),
            ),
          ),
          const SizedBox(height: 24),
          const Text('Choose a date', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          InkWell(
            onTap: _selectDate,
            borderRadius: BorderRadius.circular(14),
            child: Ink(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppTheme.border)),
              child: Row(children: [
                const Icon(Icons.calendar_month_rounded, color: AppTheme.primary),
                const SizedBox(width: 12),
                Expanded(child: Text(_formatDate(selectedDate), style: const TextStyle(fontWeight: FontWeight.w700))),
                const Icon(Icons.chevron_right_rounded, color: AppTheme.textSecondary),
              ]),
            ),
          ),
          const SizedBox(height: 24),
          const Text('Available times', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 9,
            runSpacing: 9,
            children: times.map((time) => ChoiceChip(
              label: Text(time),
              selected: selectedTime == time,
              onSelected: (_) => setState(() => selectedTime = time),
            )).toList(),
          ),
          const SizedBox(height: 24),
          const Text('Reason for visit', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            initialValue: selectedReason,
            decoration: const InputDecoration(prefixIcon: Icon(Icons.medical_information_outlined)),
            items: reasons.map((reason) => DropdownMenuItem(value: reason, child: Text(reason))).toList(),
            onChanged: (value) { if (value != null) setState(() => selectedReason = value); },
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(14)),
            child: const Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Icon(Icons.info_outline_rounded, color: AppTheme.primary, size: 20),
              SizedBox(width: 10),
              Expanded(child: Text('You can reschedule or cancel this appointment later from My Appointments.', style: TextStyle(fontSize: 12, color: AppTheme.textSecondary, height: 1.4))),
            ]),
          ),
          const SizedBox(height: 28),
          ElevatedButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ConfirmBookingPage(
              doctorName: widget.doctor.name,
              speciality: widget.doctor.speciality,
              date: _formatDate(selectedDate),
              time: selectedTime,
              reason: selectedReason,
              fee: widget.doctor.fee,
            ))),
            child: const Text('Review Appointment'),
          ),
        ],
      ),
    );
  }
}
