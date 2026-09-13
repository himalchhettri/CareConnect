import 'package:flutter/material.dart';

import 'app_data.dart';
import 'app_theme.dart';
import 'appointments_page.dart';
import 'auth_service.dart';
import 'change_password_page.dart';
import 'doctor_page.dart';
import 'home_page.dart';
import 'login_page.dart';
import 'medications_page.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  Future<void> _editProfile() async {
    final nameController = TextEditingController(text: AppData.userName);
    final emailController = TextEditingController(text: AppData.userEmail);
    final phoneController = TextEditingController(text: AppData.userPhone);

    final saved = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Edit profile'),
        content: SizedBox(
          width: 420,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full name',
                    prefixIcon: Icon(Icons.person_outline_rounded),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.mail_outline_rounded),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Phone',
                    prefixIcon: Icon(Icons.phone_outlined),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final name = nameController.text.trim();
              final email = emailController.text.trim();

              if (name.isEmpty || !email.contains('@') || !email.contains('.')) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Enter a valid name and email address.'),
                  ),
                );
                return;
              }

              Navigator.pop(dialogContext, true);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (saved == true) {
      final name = nameController.text.trim();
      final email = emailController.text.trim().toLowerCase();
      final phone = phoneController.text.trim();

      await AuthService.updateProfile(
        name: name,
        email: email,
        phone: phone,
      );

      AppData.userName = name;
      AppData.userEmail = email;
      AppData.userPhone = phone;

      if (mounted) {
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully.')),
        );
      }
    }

    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
  }

  Future<void> _logout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Log out?'),
        content: const Text(
          'You will return to the sign-in screen. Your registered account will remain saved.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.danger,
              foregroundColor: Colors.white,
            ),
            child: const Text('Log out'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    await AuthService.logout();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  void _goToTab(int index) {
    if (index == 4) return;

    Widget page;
    switch (index) {
      case 0:
        page = const HomePage();
        break;
      case 1:
        page = const FindDoctorPage();
        break;
      case 2:
        page = const AppointmentsPage();
        break;
      case 3:
        page = const MedicationsPage();
        break;
      default:
        return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 6),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w800,
          color: AppTheme.textSecondary,
        ),
      ),
    );
  }

  Widget _menuTile({
    required IconData icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
    Widget? trailing,
    Color? iconColor,
  }) {
    final color = iconColor ?? AppTheme.primary;

    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 3),
      leading: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: color, size: 21),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
      ),
      subtitle: subtitle == null
          ? null
          : Text(
              subtitle,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 12,
              ),
            ),
      trailing: trailing ?? const Icon(Icons.chevron_right_rounded),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Account')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 30),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 34,
                    backgroundColor: AppTheme.primary.withValues(alpha: 0.12),
                    child: Text(
                      AppData.userName.isEmpty
                          ? 'U'
                          : AppData.userName[0].toUpperCase(),
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppData.userName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          AppData.userEmail,
                          style: const TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          AppData.userPhone,
                          style: const TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: _editProfile,
                    tooltip: 'Edit profile',
                    icon: const Icon(Icons.edit_outlined),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          _sectionTitle('ACCOUNT'),
          Card(
            child: Column(
              children: [
                _menuTile(
                  icon: Icons.person_outline_rounded,
                  title: 'Edit profile',
                  subtitle: 'Name, email and phone',
                  onTap: _editProfile,
                ),
                const Divider(height: 1, indent: 70),
                _menuTile(
                  icon: Icons.lock_outline_rounded,
                  title: 'Password & security',
                  subtitle: 'Change your password',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ChangePasswordPage(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _sectionTitle('NOTIFICATIONS'),
          Card(
            child: Column(
              children: [
                _menuTile(
                  icon: Icons.calendar_month_outlined,
                  title: 'Appointment reminders',
                  trailing: Switch(
                    value: AppData.appointmentNotifications,
                    onChanged: (value) => setState(
                      () => AppData.appointmentNotifications = value,
                    ),
                  ),
                ),
                const Divider(height: 1, indent: 70),
                _menuTile(
                  icon: Icons.medication_outlined,
                  title: 'Medication reminders',
                  trailing: Switch(
                    value: AppData.medicationNotifications,
                    onChanged: (value) => setState(
                      () => AppData.medicationNotifications = value,
                    ),
                  ),
                ),
                const Divider(height: 1, indent: 70),
                _menuTile(
                  icon: Icons.lightbulb_outline_rounded,
                  title: 'Health tips',
                  trailing: Switch(
                    value: AppData.healthTips,
                    onChanged: (value) => setState(
                      () => AppData.healthTips = value,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _sectionTitle('SUPPORT & PRIVACY'),
          Card(
            child: Column(
              children: [
                _menuTile(
                  icon: Icons.shield_outlined,
                  title: 'Privacy & data',
                  subtitle: 'How your information is handled',
                  onTap: () => showDialog(
                    context: context,
                    builder: (dialogContext) => AlertDialog(
                      title: const Text('Privacy & data'),
                      content: const Text(
                        'This assessment prototype stores account details locally on this device. Health information is not transmitted to a server.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(dialogContext),
                          child: const Text('Close'),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(height: 1, indent: 70),
                _menuTile(
                  icon: Icons.help_outline_rounded,
                  title: 'Help & support',
                  subtitle: 'FAQ and contact support',
                  onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Support centre is a prototype feature.',
                      ),
                    ),
                  ),
                ),
                const Divider(height: 1, indent: 70),
                _menuTile(
                  icon: Icons.info_outline_rounded,
                  title: 'About CareConnect',
                  subtitle: 'Version 1.0.0 • Assessment prototype',
                  onTap: () => showAboutDialog(
                    context: context,
                    applicationName: 'CareConnect',
                    applicationVersion: '1.0.0',
                    applicationLegalese:
                        'Cross-platform healthcare management prototype.',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          OutlinedButton.icon(
            onPressed: _logout,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.danger,
              side: const BorderSide(color: Color(0xFFFECACA)),
            ),
            icon: const Icon(Icons.logout_rounded),
            label: const Text('Log Out'),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 4,
        onDestinationSelected: _goToTab,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.medical_services_outlined),
            selectedIcon: Icon(Icons.medical_services_rounded),
            label: 'Doctors',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month_rounded),
            label: 'Appointments',
          ),
          NavigationDestination(
            icon: Icon(Icons.medication_outlined),
            selectedIcon: Icon(Icons.medication_rounded),
            label: 'Medications',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}
