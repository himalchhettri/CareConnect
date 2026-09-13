import 'package:flutter/material.dart';
import 'app_data.dart';
import 'app_theme.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final hasItems = AppData.appointments.isNotEmpty || AppData.reminders.isNotEmpty;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          if (hasItems)
            TextButton(onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('All notifications marked as read'))), child: const Text('Mark all read')),
        ],
      ),
      body: hasItems
          ? ListView(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
              children: [
                if (AppData.reminders.isNotEmpty) ...[
                  const _SectionTitle('MEDICATION'),
                  ...AppData.reminders.reversed.map((reminder) => _NotificationCard(
                        icon: Icons.medication_rounded,
                        title: 'Medication reminder',
                        message: '${reminder.medicineName} ${reminder.dosage}',
                        meta: '${reminder.time.format(context)} • ${reminder.days.join(', ')}',
                        color: AppTheme.accent,
                      )),
                ],
                if (AppData.appointments.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  const _SectionTitle('APPOINTMENTS'),
                  ...AppData.appointments.reversed.map((appointment) => _NotificationCard(
                        icon: Icons.calendar_month_rounded,
                        title: 'Appointment confirmed',
                        message: appointment.doctorName,
                        meta: '${appointment.date} • ${appointment.time}',
                        color: AppTheme.primary,
                      )),
                ],
              ],
            )
          : const Center(
              child: Padding(
                padding: EdgeInsets.all(30),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.notifications_none_rounded, size: 62, color: AppTheme.textSecondary),
                  SizedBox(height: 14),
                  Text('You are all caught up', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800)),
                  SizedBox(height: 6),
                  Text('Appointment confirmations and medication reminders will appear here.', textAlign: TextAlign.center, style: TextStyle(color: AppTheme.textSecondary)),
                ]),
              ),
            ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 9, top: 4),
        child: Text(text, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppTheme.textSecondary)),
      );
}

class _NotificationCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String meta;
  final Color color;
  const _NotificationCard({required this.icon, required this.title, required this.message, required this.meta, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: color.withValues(alpha: 0.10), borderRadius: BorderRadius.circular(13)),
            child: Icon(icon, color: color, size: 21),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13))),
              Container(width: 7, height: 7, decoration: const BoxDecoration(color: AppTheme.primary, shape: BoxShape.circle)),
            ]),
            const SizedBox(height: 4),
            Text(message, style: const TextStyle(fontSize: 12)),
            const SizedBox(height: 4),
            Text(meta, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
          ])),
        ]),
      ),
    );
  }
}
