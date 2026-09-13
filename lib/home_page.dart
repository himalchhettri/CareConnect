import 'package:flutter/material.dart';
import 'account_page.dart';
import 'app_data.dart';
import 'app_theme.dart';
import 'appointments_page.dart';
import 'doctor_page.dart';
import 'medications_page.dart';
import 'notifications_page.dart';
import 'reminders_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> _open(Widget page) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => page,
      ),
    );

    if (mounted) {
      setState(() {});
    }
  }

  Widget _quickAction({
    required IconData icon,
    required String label,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Ink(
        width: 160,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: AppTheme.border,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(
                icon,
                color: color,
                size: 22,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 11,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleBottomNavigation(int index) {
    switch (index) {
      case 0:
        // Already on Home
        break;

      case 1:
        _open(const FindDoctorPage());
        break;

      case 2:
        _open(const AppointmentsPage());
        break;

      case 3:
        _open(const MedicationsPage());
        break;

      case 4:
        _open(const AccountPage());
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final appointment = AppData.appointments.isNotEmpty
        ? AppData.appointments.last
        : null;

    final reminder =
        AppData.reminders.isNotEmpty ? AppData.reminders.last : null;

    final notificationCount =
        AppData.appointments.length + AppData.reminders.length;

    return Scaffold(
      backgroundColor: AppTheme.background,

      // ---------------- BODY ----------------
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            setState(() {});
          },
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              18,
              16,
              18,
              30,
            ),
            children: [
              // ---------------- HEADER ----------------
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          AppTheme.primaryDark,
                          AppTheme.primary,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.favorite_rounded,
                      color: Colors.white,
                      size: 23,
                    ),
                  ),

                  const SizedBox(width: 12),

                  const Expanded(
                    child: Text(
                      'CareConnect',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),

                  // Notifications
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      IconButton(
                        onPressed: () {
                          _open(const NotificationsPage());
                        },
                        icon: const Icon(
                          Icons.notifications_none_rounded,
                        ),
                      ),

                      if (notificationCount > 0)
                        Positioned(
                          right: 7,
                          top: 5,
                          child: Container(
                            constraints: const BoxConstraints(
                              minWidth: 17,
                              minHeight: 17,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                            ),
                            decoration: const BoxDecoration(
                              color: AppTheme.danger,
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              notificationCount > 9
                                  ? '9+'
                                  : '$notificationCount',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(width: 4),

                  // Account avatar
                  InkWell(
                    onTap: () {
                      _open(const AccountPage());
                    },
                    borderRadius: BorderRadius.circular(30),
                    child: CircleAvatar(
                      radius: 19,
                      backgroundColor:
                          AppTheme.primary.withValues(alpha: 0.12),
                      child: Text(
                        AppData.userName.isEmpty
                            ? 'U'
                            : AppData.userName[0].toUpperCase(),
                        style: const TextStyle(
                          color: AppTheme.primary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // ---------------- GREETING ----------------
              Text(
                'Hello, ${AppData.userName} 👋',
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.4,
                ),
              ),

              const SizedBox(height: 5),

              const Text(
                'How can we help you today?',
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 20),

              // ---------------- SEARCH ----------------
              TextField(
                readOnly: true,
                onTap: () {
                  _open(const FindDoctorPage());
                },
                decoration: const InputDecoration(
                  hintText: 'Search doctors or specialities',
                  prefixIcon: Icon(
                    Icons.search_rounded,
                  ),
                  suffixIcon: Icon(
                    Icons.tune_rounded,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ---------------- QUICK ACTIONS ----------------
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Quick actions',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      _open(const FindDoctorPage());
                    },
                    child: const Text(
                      'Find care',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _quickAction(
                    icon: Icons.medical_services_outlined,
                    label: 'Find Doctor',
                    subtitle: 'Search specialists',
                    color: AppTheme.primary,
                    onTap: () {
                      _open(const FindDoctorPage());
                    },
                  ),

                  _quickAction(
                    icon: Icons.calendar_month_outlined,
                    label: 'Appointments',
                    subtitle:
                        '${AppData.appointments.length} upcoming',
                    color: const Color(0xFF7C3AED),
                    onTap: () {
                      _open(const AppointmentsPage());
                    },
                  ),

                  _quickAction(
                    icon: Icons.medication_outlined,
                    label: 'Medications',
                    subtitle:
                        '${AppData.medications.length} medicines',
                    color: AppTheme.accent,
                    onTap: () {
                      _open(const MedicationsPage());
                    },
                  ),

                  _quickAction(
                    icon: Icons.alarm_outlined,
                    label: 'Reminders',
                    subtitle:
                        '${AppData.reminders.length} active',
                    color: const Color(0xFFF59E0B),
                    onTap: () {
                      _open(const RemindersPage());
                    },
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // ---------------- APPOINTMENTS ----------------
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Upcoming appointment',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  if (appointment != null)
                    TextButton(
                      onPressed: () {
                        _open(const AppointmentsPage());
                      },
                      child: const Text(
                        'View all',
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 10),

              if (appointment == null)
                _EmptyActionCard(
                  icon: Icons.event_available_rounded,
                  title: 'No appointment booked',
                  subtitle:
                      'Find a doctor and choose a time that suits you.',
                  buttonText: 'Book appointment',
                  onPressed: () {
                    _open(const FindDoctorPage());
                  },
                )
              else
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: AppTheme.primary
                                    .withValues(alpha: 0.10),
                                borderRadius:
                                    BorderRadius.circular(15),
                              ),
                              child: const Icon(
                                Icons.person_rounded,
                                color: AppTheme.primary,
                              ),
                            ),

                            const SizedBox(width: 13),

                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    appointment.doctorName,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight:
                                          FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    appointment.speciality,
                                    style: const TextStyle(
                                      color:
                                          AppTheme.textSecondary,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Container(
                              padding:
                                  const EdgeInsets.symmetric(
                                horizontal: 9,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFDCFCE7),
                                borderRadius:
                                    BorderRadius.circular(99),
                              ),
                              child: const Text(
                                'Confirmed',
                                style: TextStyle(
                                  color: Color(0xFF15803D),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppTheme.background,
                            borderRadius:
                                BorderRadius.circular(14),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.calendar_today_outlined,
                                size: 18,
                                color: AppTheme.primary,
                              ),
                              const SizedBox(width: 8),

                              Expanded(
                                child: Text(
                                  appointment.date,
                                  style: const TextStyle(
                                    fontWeight:
                                        FontWeight.w700,
                                    fontSize: 12,
                                  ),
                                ),
                              ),

                              const Icon(
                                Icons.schedule_rounded,
                                size: 18,
                                color: AppTheme.primary,
                              ),

                              const SizedBox(width: 6),

                              Text(
                                appointment.time,
                                style: const TextStyle(
                                  fontWeight:
                                      FontWeight.w700,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),

                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () {
                              _open(
                                const AppointmentsPage(),
                              );
                            },
                            child: const Text(
                              'Manage appointment',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: 26),

              // ---------------- MEDICATION REMINDER ----------------
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Next medication reminder',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  if (reminder != null)
                    TextButton(
                      onPressed: () {
                        _open(const RemindersPage());
                      },
                      child: const Text(
                        'View all',
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 10),

              if (reminder == null)
                _EmptyActionCard(
                  icon:
                      Icons.notifications_active_outlined,
                  title: 'No reminder set',
                  subtitle:
                      'Create a medication reminder to stay on schedule.',
                  buttonText: 'Set reminder',
                  onPressed: () {
                    _open(const MedicationsPage());
                  },
                )
              else
                Card(
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppTheme.accent
                            .withValues(alpha: 0.12),
                        borderRadius:
                            BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.medication_rounded,
                        color: AppTheme.accent,
                      ),
                    ),
                    title: Text(
                      reminder.medicineName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    subtitle: Padding(
                      padding:
                          const EdgeInsets.only(top: 5),
                      child: Text(
                        '${reminder.dosage} • ${reminder.days.join(', ')}',
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                    trailing: Text(
                      reminder.time.format(context),
                      style: const TextStyle(
                        color: AppTheme.primary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    onTap: () {
                      _open(const RemindersPage());
                    },
                  ),
                ),
            ],
          ),
        ),
      ),

      // ---------------- 5 ITEM BOTTOM NAVIGATION ----------------
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        height: 72,
        onDestinationSelected: _handleBottomNavigation,
        destinations: const [
          NavigationDestination(
            icon: Icon(
              Icons.home_outlined,
            ),
            selectedIcon: Icon(
              Icons.home_rounded,
            ),
            label: 'Home',
          ),

          NavigationDestination(
            icon: Icon(
              Icons.medical_services_outlined,
            ),
            selectedIcon: Icon(
              Icons.medical_services_rounded,
            ),
            label: 'Doctors',
          ),

          NavigationDestination(
            icon: Icon(
              Icons.calendar_month_outlined,
            ),
            selectedIcon: Icon(
              Icons.calendar_month_rounded,
            ),
            label: 'Appointments',
          ),

          NavigationDestination(
            icon: Icon(
              Icons.medication_outlined,
            ),
            selectedIcon: Icon(
              Icons.medication_rounded,
            ),
            label: 'Medications',
          ),

          NavigationDestination(
            icon: Icon(
              Icons.person_outline_rounded,
            ),
            selectedIcon: Icon(
              Icons.person_rounded,
            ),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}

// ---------------- EMPTY CARD ----------------

class _EmptyActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String buttonText;
  final VoidCallback onPressed;

  const _EmptyActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color:
                    AppTheme.primary.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(
                icon,
                color: AppTheme.primary,
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 10),

            TextButton(
              onPressed: onPressed,
              child: Text(
                buttonText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}