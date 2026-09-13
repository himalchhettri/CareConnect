import 'package:flutter/material.dart';
import 'app_data.dart';
import 'set_reminder_page.dart';

class MedicationDetailsPage extends StatefulWidget {
  final Medication medication;

  const MedicationDetailsPage({
    super.key,
    required this.medication,
  });

  @override
  State<MedicationDetailsPage> createState() =>
      _MedicationDetailsPageState();
}

class _MedicationDetailsPageState
    extends State<MedicationDetailsPage> {
  static const Color careBlue = Color(0xFF22A9F0);

  late Medication medication;

  @override
  void initState() {
    super.initState();
    medication = widget.medication;
  }

  // ---------------- DETAIL ROW ----------------

  Widget detailRow(
    IconData icon,
    String title,
    String value,
  ) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: careBlue.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              size: 20,
              color: careBlue,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- FIND REMINDER ----------------

  MedicationReminder? get reminder {
    for (final item in AppData.reminders.reversed) {
      if (item.medicineName == medication.name) {
        return item;
      }
    }
    return null;
  }

  // ---------------- EDIT MEDICATION ----------------

  Future<void> _editMedication() async {
    final nameController =
        TextEditingController(text: medication.name);

    final doseController =
        TextEditingController(text: medication.dose);

    final frequencyController =
        TextEditingController(text: medication.frequency);

    final instructionsController =
        TextEditingController(text: medication.instructions);

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 500,
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Edit Medication',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 5),

                    const Text(
                      'Update your medication information.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(height: 24),

                    const Text(
                      'Medication name',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 7),

                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        hintText: 'Medication name',
                        prefixIcon:
                            Icon(Icons.medication_outlined),
                      ),
                    ),

                    const SizedBox(height: 18),

                    const Text(
                      'Dose',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 7),

                    TextField(
                      controller: doseController,
                      decoration: const InputDecoration(
                        hintText: 'e.g. 500 mg',
                        prefixIcon:
                            Icon(Icons.science_outlined),
                      ),
                    ),

                    const SizedBox(height: 18),

                    const Text(
                      'Frequency',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 7),

                    TextField(
                      controller: frequencyController,
                      decoration: const InputDecoration(
                        hintText: 'e.g. Once Daily',
                        prefixIcon:
                            Icon(Icons.repeat_rounded),
                      ),
                    ),

                    const SizedBox(height: 18),

                    const Text(
                      'Instructions',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 7),

                    TextField(
                      controller: instructionsController,
                      minLines: 2,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        hintText: 'e.g. Take after food',
                        prefixIcon:
                            Icon(Icons.info_outline),
                      ),
                    ),

                    const SizedBox(height: 26),

                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.pop(
                                dialogContext,
                                false,
                              );
                            },
                            child: const Text('Cancel'),
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(
                                dialogContext,
                                true,
                              );
                            },
                            icon: const Icon(
                              Icons.save_rounded,
                            ),
                            label: const Text('Save'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    if (result == true) {
      final newName = nameController.text.trim();
      final newDose = doseController.text.trim();
      final newFrequency =
          frequencyController.text.trim();
      final newInstructions =
          instructionsController.text.trim();

      if (newName.isEmpty || newDose.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Medication name and dose are required.',
              ),
            ),
          );
        }
      } else {
        final index =
            AppData.medications.indexOf(medication);

        if (index != -1) {
          final oldName = medication.name;

          final updatedMedication = Medication(
            name: newName,
            dose: newDose,
            frequency: newFrequency.isEmpty
                ? 'Once Daily'
                : newFrequency,
            instructions: newInstructions.isEmpty
                ? 'Take as directed'
                : newInstructions,
          );

          AppData.medications[index] = updatedMedication;

          // MedicationReminder fields are immutable. If the medication name
          // changes, replace the reminder object instead of trying to mutate it.
          final reminderIndex = AppData.reminders.indexWhere(
            (item) => item.medicineName == oldName,
          );

          if (reminderIndex != -1) {
            final existingReminder = AppData.reminders[reminderIndex];
            AppData.reminders[reminderIndex] = MedicationReminder(
              medicineName: newName,
              dosage: newDose,
              time: existingReminder.time,
              days: List<String>.from(existingReminder.days),
              message: existingReminder.message,
            );
          }

          setState(() {
            medication = updatedMedication;
          });

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Medication updated successfully.',
                ),
              ),
            );
          }
        }
      }
    }

    nameController.dispose();
    doseController.dispose();
    frequencyController.dispose();
    instructionsController.dispose();
  }

  // ---------------- DELETE MEDICATION ----------------

  Future<void> _deleteMedication() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Delete Medication',
          ),
          content: Text(
            'Are you sure you want to delete ${medication.name}?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  false,
                );
              },
              child: const Text('Cancel'),
            ),

            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  true,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              icon: const Icon(
                Icons.delete_outline,
              ),
              label: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      // Remove medication
      AppData.medications.remove(medication);

      // Remove its reminder as well
      AppData.reminders.removeWhere(
        (item) =>
            item.medicineName == medication.name,
      );

      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  // ---------------- PAGE ----------------

  @override
  Widget build(BuildContext context) {
    final currentReminder = reminder;

    final reminderText = currentReminder == null
        ? 'Not set'
        : '${currentReminder.time.format(context)} • '
            '${currentReminder.days.join(', ')}';

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Medication Details',
          style: TextStyle(
            color: Colors.black,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),

        actions: [
          IconButton(
            tooltip: 'Edit medication',
            onPressed: _editMedication,
            icon: const Icon(
              Icons.edit_outlined,
              color: careBlue,
            ),
          ),
        ],
      ),

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            20,
            20,
            20,
            30,
          ),
          children: [
            // Medication icon

            Center(
              child: Container(
                width: 82,
                height: 82,
                decoration: BoxDecoration(
                  color:
                      careBlue.withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.medication_rounded,
                  size: 42,
                  color: careBlue,
                ),
              ),
            ),

            const SizedBox(height: 18),

            // Medication name

            Text(
              medication.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              medication.dose,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 32),

            const Text(
              'Medication Information',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 14),

            detailRow(
              Icons.medication_outlined,
              'Dosage',
              medication.dose,
            ),

            detailRow(
              Icons.repeat_rounded,
              'Frequency',
              medication.frequency,
            ),

            detailRow(
              Icons.info_outline_rounded,
              'Instructions',
              medication.instructions,
            ),

            detailRow(
              Icons.notifications_outlined,
              'Reminder',
              reminderText,
            ),

            const SizedBox(height: 10),

            // Edit button

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _editMedication,
                icon: const Icon(
                  Icons.edit_rounded,
                ),
                label: const Text(
                  'Edit Medication',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: careBlue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(14),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Reminder button

            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          SetReminderPage(
                        medication: medication,
                      ),
                    ),
                  );

                  if (mounted) {
                    setState(() {});
                  }
                },
                icon: const Icon(
                  Icons.notifications_active_outlined,
                ),
                label: Text(
                  currentReminder == null
                      ? 'Set Reminder'
                      : 'Update Reminder',
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: careBlue,
                  side: const BorderSide(
                    color: careBlue,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(14),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Delete button

            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                onPressed: _deleteMedication,
                icon: const Icon(
                  Icons.delete_outline_rounded,
                ),
                label: const Text(
                  'Delete Medication',
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(
                    color: Colors.red,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}