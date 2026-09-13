import 'package:flutter/material.dart';
import 'app_data.dart';
import 'app_theme.dart';
import 'medications_page.dart';

class RemindersPage extends StatefulWidget {
  const RemindersPage({super.key});

  @override
  State<RemindersPage> createState() => _RemindersPageState();
}

class _RemindersPageState extends State<RemindersPage> {
  @override
  Widget build(BuildContext context) {
    final reminders = AppData.reminders.reversed.toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Medication Reminders')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (_) => const MedicationsPage()));
          if (mounted) setState(() {});
        },
        icon: const Icon(Icons.add_alarm_rounded),
        label: const Text('Add reminder'),
      ),
      body: reminders.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(color: AppTheme.primary.withValues(alpha: 0.1), shape: BoxShape.circle),
                    child: const Icon(Icons.alarm_off_rounded, size: 36, color: AppTheme.primary),
                  ),
                  const SizedBox(height: 18),
                  const Text('No reminders yet', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 8),
                  const Text('Choose a medication and create a reminder so you can keep track of your schedule.', textAlign: TextAlign.center, style: TextStyle(color: AppTheme.textSecondary)),
                ]),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 100),
              itemCount: reminders.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final reminder = reminders[index];
                final originalIndex = AppData.reminders.indexOf(reminder);
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(color: AppTheme.accent.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(14)),
                        child: const Icon(Icons.medication_rounded, color: AppTheme.accent),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Row(children: [
                            Expanded(child: Text(reminder.medicineName, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15))),
                            Text(reminder.time.format(context), style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.w800)),
                          ]),
                          const SizedBox(height: 4),
                          Text(reminder.dosage, style: const TextStyle(color: AppTheme.textSecondary)),
                          const SizedBox(height: 8),
                          Text(reminder.days.join(' • '), style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                          const SizedBox(height: 8),
                          Text(reminder.message, style: const TextStyle(fontSize: 12)),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton.icon(
                              onPressed: () {
                                AppData.removeReminder(originalIndex);
                                setState(() {});
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Reminder removed')));
                              },
                              icon: const Icon(Icons.delete_outline_rounded, size: 18),
                              label: const Text('Remove'),
                            ),
                          ),
                        ]),
                      ),
                    ]),
                  ),
                );
              },
            ),
    );
  }
}
