import 'package:flutter/material.dart';
import 'account_page.dart';
import 'app_data.dart';
import 'app_theme.dart';
import 'doctor_page.dart';
import 'home_page.dart';

class AppointmentsPage extends StatefulWidget {
  const AppointmentsPage({super.key});

  @override
  State<AppointmentsPage> createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage> {
  Future<void> _cancelAppointment(int index) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Cancel appointment?'),
        content: const Text('This appointment will be removed from your upcoming appointments.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('Keep appointment')),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.danger),
            child: const Text('Cancel appointment'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      AppData.removeAppointment(index);
      setState(() {});
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Appointment cancelled')));
    }
  }

  Future<void> _rescheduleAppointment(int index) async {
    final appointment = AppData.appointments[index];
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final newDate = await showDatePicker(
      context: context,
      initialDate: today,
      firstDate: today,
      lastDate: DateTime(today.year + 1, today.month, today.day),
    );
    if (newDate == null || !mounted) return;
    final newTime = await showTimePicker(context: context, initialTime: const TimeOfDay(hour: 10, minute: 30));
    if (newTime == null || !mounted) return;
    AppData.updateAppointment(
      index,
      Appointment(
        doctorName: appointment.doctorName,
        speciality: appointment.speciality,
        date: '${newDate.day}/${newDate.month}/${newDate.year}',
        time: newTime.format(context),
        reason: appointment.reason,
        fee: appointment.fee,
      ),
    );
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Appointment rescheduled successfully')));
  }

  Widget _emptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            width: 82,
            height: 82,
            decoration: BoxDecoration(color: AppTheme.primary.withValues(alpha: 0.1), shape: BoxShape.circle),
            child: const Icon(Icons.event_busy_rounded, size: 38, color: AppTheme.primary),
          ),
          const SizedBox(height: 18),
          const Text('No upcoming appointments', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          const Text('Find a doctor and book an appointment that fits your schedule.', textAlign: TextAlign.center, style: TextStyle(color: AppTheme.textSecondary)),
          const SizedBox(height: 18),
          SizedBox(width: 210, child: ElevatedButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FindDoctorPage())), child: const Text('Find a doctor'))),
        ]),
      ),
    );
  }

  Widget _appointmentCard(Appointment appointment, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(color: AppTheme.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(15)),
              child: const Icon(Icons.person_rounded, color: AppTheme.primary),
            ),
            const SizedBox(width: 13),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(appointment.doctorName, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
              const SizedBox(height: 3),
              Text(appointment.speciality, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
            ])),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
              decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(99)),
              child: const Text('Confirmed', style: TextStyle(color: Color(0xFF15803D), fontSize: 10, fontWeight: FontWeight.w800)),
            ),
          ]),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(color: AppTheme.background, borderRadius: BorderRadius.circular(14)),
            child: Column(children: [
              _detailRow(Icons.calendar_today_outlined, 'Date', appointment.date),
              const SizedBox(height: 11),
              _detailRow(Icons.schedule_rounded, 'Time', appointment.time),
              const SizedBox(height: 11),
              _detailRow(Icons.medical_information_outlined, 'Reason', appointment.reason),
              const SizedBox(height: 11),
              _detailRow(Icons.payments_outlined, 'Consultation fee', '\$${appointment.fee.toStringAsFixed(0)}'),
            ]),
          ),
          const SizedBox(height: 14),
          Row(children: [
            Expanded(child: OutlinedButton.icon(onPressed: () => _rescheduleAppointment(index), icon: const Icon(Icons.edit_calendar_outlined, size: 18), label: const Text('Reschedule'))),
            const SizedBox(width: 10),
            Expanded(child: OutlinedButton.icon(
              onPressed: () => _cancelAppointment(index),
              style: OutlinedButton.styleFrom(foregroundColor: AppTheme.danger, side: const BorderSide(color: Color(0xFFFECACA))),
              icon: const Icon(Icons.close_rounded, size: 18),
              label: const Text('Cancel'),
            )),
          ]),
        ]),
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Row(children: [
      Icon(icon, size: 18, color: AppTheme.primary),
      const SizedBox(width: 9),
      SizedBox(width: 96, child: Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary))),
      Expanded(child: Text(value, textAlign: TextAlign.right, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700))),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Appointments'),
          bottom: const TabBar(tabs: [Tab(text: 'Upcoming'), Tab(text: 'Past')]),
        ),
        body: TabBarView(children: [
          AppData.appointments.isEmpty
              ? _emptyState()
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(18, 16, 18, 30),
                  itemCount: AppData.appointments.length,
                  itemBuilder: (context, index) => _appointmentCard(AppData.appointments[index], index),
                ),
          const Center(child: Text('No past appointments yet.', style: TextStyle(color: AppTheme.textSecondary))),
        ]),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 1,
          onTap: (index) {
            if (index == 0) {
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const HomePage()), (route) => false);
            } else if (index == 2) {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AccountPage()));
            }
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.calendar_month_rounded), label: 'Appointments'),
            BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Account'),
          ],
        ),
      ),
    );
  }
}
