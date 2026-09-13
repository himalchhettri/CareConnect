import 'package:flutter/material.dart';
import 'app_data.dart';
import 'reminder_created_page.dart';

class SetReminderPage extends StatefulWidget {
  final Medication medication;
  const SetReminderPage({super.key, required this.medication});

  @override
  State<SetReminderPage> createState() => _SetReminderPageState();
}

class _SetReminderPageState extends State<SetReminderPage> {
  static const Color careBlue = Color(0xFF22A9F0);
  TimeOfDay selectedTime = const TimeOfDay(hour: 8, minute: 0);
  final List<String> days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
  final List<bool> selectedDays = List<bool>.filled(7, true);
  late final TextEditingController messageController;

  @override
  void initState() {
    super.initState();
    messageController = TextEditingController(text: 'Time to take ${widget.medication.name}');
    for (final reminder in AppData.reminders.reversed) {
      if (reminder.medicineName == widget.medication.name) {
        selectedTime = reminder.time;
        for (var i = 0; i < days.length; i++) {
          selectedDays[i] = reminder.days.contains(days[i]);
        }
        messageController.text = reminder.message;
        break;
      }
    }
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  Future<void> chooseTime() async {
    final picked = await showTimePicker(context: context, initialTime: selectedTime);
    if (picked != null) setState(() => selectedTime = picked);
  }

  void _saveReminder() {
    final selected = <String>[];
    for (var i = 0; i < days.length; i++) {
      if (selectedDays[i]) selected.add(days[i]);
    }
    if (selected.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Select at least one repeat day.')));
      return;
    }

    final reminder = MedicationReminder(
      medicineName: widget.medication.name,
      dosage: widget.medication.dose,
      time: selectedTime,
      days: selected,
      message: messageController.text.trim().isEmpty ? 'Time to take ${widget.medication.name}' : messageController.text.trim(),
    );
    AppData.addReminder(reminder);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ReminderCreatedPage(reminder: reminder)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0, centerTitle: true, title: const Text('Set Reminder', style: TextStyle(color: Colors.black, fontSize: 15))),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 15),
          children: [
            const Text('Medication', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(border: Border.all(color: careBlue), borderRadius: BorderRadius.circular(8)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(widget.medication.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(widget.medication.dose, style: const TextStyle(fontSize: 10)),
              ]),
            ),
            const SizedBox(height: 25),
            const Text('Reminder Time', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            InkWell(
              onTap: chooseTime,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 15),
                decoration: BoxDecoration(border: Border.all(color: careBlue), borderRadius: BorderRadius.circular(8)),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(selectedTime.format(context), style: const TextStyle(fontSize: 12)), const Icon(Icons.access_time, size: 19)]),
              ),
            ),
            const SizedBox(height: 25),
            const Text('Repeat', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(days.length, (index) => FilterChip(
                label: Text(days[index]),
                selected: selectedDays[index],
                onSelected: (value) => setState(() => selectedDays[index] = value),
              )),
            ),
            const SizedBox(height: 25),
            const Text('Reminder Message', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            TextField(controller: messageController, maxLines: 3, decoration: const InputDecoration(border: OutlineInputBorder())),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                onPressed: _saveReminder,
                style: ElevatedButton.styleFrom(backgroundColor: careBlue, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                child: const Text('Save Reminder'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
