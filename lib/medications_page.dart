import 'package:flutter/material.dart';
import 'app_data.dart';
import 'app_theme.dart';
import 'medication_details_page.dart';

class MedicationsPage extends StatefulWidget {
  const MedicationsPage({super.key});

  @override
  State<MedicationsPage> createState() => _MedicationsPageState();
}

class _MedicationsPageState extends State<MedicationsPage> {
  Future<void> _addMedication() async {
    final nameController = TextEditingController();
    final doseController = TextEditingController();
    final frequencyController = TextEditingController(text: 'Once Daily');
    final instructionsController =
        TextEditingController(text: 'Take as directed');

    final shouldAdd = await showDialog<bool>(
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
              padding: const EdgeInsets.fromLTRB(
                24,
                22,
                24,
                22,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ---------------- HEADER ----------------

                    Row(
                      children: [
                        Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            color: AppTheme.primary.withValues(
                              alpha: 0.10,
                            ),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.medication_rounded,
                            color: AppTheme.primary,
                          ),
                        ),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Add Medication',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              SizedBox(height: 3),
                              Text(
                                'Enter your medication information below.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // ---------------- MEDICATION NAME ----------------

                    const Text(
                      'Medication name',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 7),

                    TextField(
                      controller: nameController,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        hintText: 'e.g. Amoxicillin',
                        prefixIcon:
                            Icon(Icons.medication_outlined),
                      ),
                    ),

                    const SizedBox(height: 18),

                    // ---------------- DOSE ----------------

                    const Text(
                      'Dose',
                      style: TextStyle(
                        fontSize: 13,
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

                    // ---------------- FREQUENCY ----------------

                    const Text(
                      'Frequency',
                      style: TextStyle(
                        fontSize: 13,
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

                    // ---------------- INSTRUCTIONS ----------------

                    const Text(
                      'Instructions',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 7),

                    TextField(
                      controller: instructionsController,
                      maxLines: 3,
                      minLines: 2,
                      textAlignVertical: TextAlignVertical.top,
                      decoration: const InputDecoration(
                        hintText:
                            'e.g. Take after food with water',
                        prefixIcon:
                            Padding(
                          padding: EdgeInsets.only(bottom: 38),
                          child: Icon(
                            Icons.info_outline_rounded,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 26),

                    // ---------------- BUTTONS ----------------

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
                            style: OutlinedButton.styleFrom(
                              minimumSize:
                                  const Size.fromHeight(50),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(14),
                              ),
                            ),
                            child: const Text(
                              'Cancel',
                            ),
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
                              Icons.add_rounded,
                            ),
                            label: const Text(
                              'Add Medication',
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  AppTheme.primary,
                              foregroundColor:
                                  Colors.white,
                              minimumSize:
                                  const Size.fromHeight(50),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(14),
                              ),
                            ),
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

    if (shouldAdd == true) {
      final name = nameController.text.trim();
      final dose = doseController.text.trim();

      if (name.isEmpty || dose.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Please enter medication name and dose.',
              ),
            ),
          );
        }
      } else {
        AppData.addMedication(
          Medication(
            name: name,
            dose: dose,
            frequency:
                frequencyController.text.trim().isEmpty
                    ? 'Once Daily'
                    : frequencyController.text.trim(),
            instructions:
                instructionsController.text.trim().isEmpty
                    ? 'Take as directed'
                    : instructionsController.text.trim(),
          ),
        );

        if (mounted) {
          setState(() {});

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '$name added successfully.',
              ),
            ),
          );
        }
      }
    }

    nameController.dispose();
    doseController.dispose();
    frequencyController.dispose();
    instructionsController.dispose();
  }

  MedicationReminder? _reminderFor(String name) {
    for (final reminder in AppData.reminders.reversed) {
      if (reminder.medicineName == name) {
        return reminder;
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,

      appBar: AppBar(
        title: const Text(
          'Medications',
          style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addMedication,
        icon: const Icon(
          Icons.add_rounded,
        ),
        label: const Text(
          'Add Medication',
        ),
      ),

      body: AppData.medications.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 82,
                      height: 82,
                      decoration: BoxDecoration(
                        color: AppTheme.primary
                            .withValues(alpha: 0.10),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.medication_outlined,
                        size: 42,
                        color: AppTheme.primary,
                      ),
                    ),

                    const SizedBox(height: 18),

                    const Text(
                      'No medications yet',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 7),

                    const Text(
                      'Add your medication to manage doses and reminders.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 13,
                      ),
                    ),

                    const SizedBox(height: 20),

                    ElevatedButton.icon(
                      onPressed: _addMedication,
                      icon: const Icon(
                        Icons.add_rounded,
                      ),
                      label: const Text(
                        'Add Medication',
                      ),
                    ),
                  ],
                ),
              ),
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(
                18,
                12,
                18,
                110,
              ),
              children: [
                // ---------------- SUMMARY ----------------

                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        AppTheme.primaryDark,
                        AppTheme.primary,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(
                            alpha: 0.15,
                          ),
                          borderRadius:
                              BorderRadius.circular(15),
                        ),
                        child: const Icon(
                          Icons.medication_liquid_rounded,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),

                      const SizedBox(width: 14),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${AppData.medications.length} medications',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight:
                                    FontWeight.w800,
                                fontSize: 17,
                              ),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              '${AppData.reminders.length} active reminders',
                              style: TextStyle(
                                color: Colors.white
                                    .withValues(alpha: 0.82),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // ---------------- TITLE ----------------

                const Text(
                  'Your medications',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 12),

                // ---------------- MEDICATION CARDS ----------------

                ...AppData.medications.map(
                  (medication) {
                    final reminder =
                        _reminderFor(medication.name);

                    return Padding(
                      padding:
                          const EdgeInsets.only(bottom: 12),
                      child: Card(
                        child: InkWell(
                          borderRadius:
                              BorderRadius.circular(18),
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    MedicationDetailsPage(
                                  medication: medication,
                                ),
                              ),
                            );

                            if (mounted) {
                              setState(() {});
                            }
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.all(16),
                            child: Row(
                              crossAxisAlignment:
                                  CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 52,
                                  height: 52,
                                  decoration: BoxDecoration(
                                    color: AppTheme.accent
                                        .withValues(
                                      alpha: 0.12,
                                    ),
                                    borderRadius:
                                        BorderRadius.circular(
                                      15,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.medication_rounded,
                                    color: AppTheme.accent,
                                  ),
                                ),

                                const SizedBox(width: 14),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        medication.name,
                                        style:
                                            const TextStyle(
                                          fontSize: 15,
                                          fontWeight:
                                              FontWeight.w800,
                                        ),
                                      ),

                                      const SizedBox(height: 4),

                                      Text(
                                        '${medication.dose} • ${medication.frequency}',
                                        style:
                                            const TextStyle(
                                          fontSize: 12,
                                          color: AppTheme
                                              .textSecondary,
                                        ),
                                      ),

                                      const SizedBox(height: 9),

                                      Row(
                                        children: [
                                          Icon(
                                            reminder == null
                                                ? Icons
                                                    .notifications_off_outlined
                                                : Icons
                                                    .notifications_active_outlined,
                                            size: 16,
                                            color:
                                                reminder == null
                                                    ? AppTheme
                                                        .textSecondary
                                                    : AppTheme
                                                        .primary,
                                          ),

                                          const SizedBox(
                                              width: 5),

                                          Text(
                                            reminder == null
                                                ? 'No reminder'
                                                : reminder.time
                                                    .format(
                                                      context,
                                                    ),
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: reminder ==
                                                      null
                                                  ? AppTheme
                                                      .textSecondary
                                                  : AppTheme
                                                      .primary,
                                              fontWeight:
                                                  FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(width: 8),

                                const Icon(
                                  Icons.chevron_right_rounded,
                                  color:
                                      AppTheme.textSecondary,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
    );
  }
}