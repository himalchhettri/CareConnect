import 'package:flutter/material.dart';

import 'app_theme.dart';
import 'auth_service.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final oldController = TextEditingController();
  final newController = TextEditingController();
  final confirmController = TextEditingController();

  bool hideOld = true;
  bool hideNew = true;
  bool hideConfirm = true;
  bool loading = false;

  @override
  void dispose() {
    oldController.dispose();
    newController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final currentPassword = oldController.text;
    final newPassword = newController.text;
    final confirmPassword = confirmController.text;

    if (currentPassword.isEmpty) {
      _showMessage('Please enter your current password.');
      return;
    }

    if (newPassword.length < 6) {
      _showMessage('New password must contain at least 6 characters.');
      return;
    }

    if (newPassword != confirmPassword) {
      _showMessage('New passwords do not match.');
      return;
    }

    if (currentPassword == newPassword) {
      _showMessage('New password must be different from the current password.');
      return;
    }

    setState(() => loading = true);

    final changed = await AuthService.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );

    if (!mounted) return;

    setState(() => loading = false);

    if (!changed) {
      _showMessage('Your current password is incorrect.');
      return;
    }

    oldController.clear();
    newController.clear();
    confirmController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Password changed successfully.'),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context);
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  InputDecoration _decoration(
    String label,
    bool hidden,
    VoidCallback toggle,
  ) {
    return InputDecoration(
      labelText: label,
      prefixIcon: const Icon(Icons.lock_outline_rounded),
      suffixIcon: IconButton(
        onPressed: toggle,
        icon: Icon(
          hidden
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Password & Security'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 30),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.shield_outlined,
                      color: AppTheme.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Keep your account secure',
                          style: TextStyle(fontWeight: FontWeight.w800),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Use a unique password that you do not use for other accounts.',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.textSecondary,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 22),

          TextField(
            controller: oldController,
            obscureText: hideOld,
            enabled: !loading,
            decoration: _decoration(
              'Current password',
              hideOld,
              () => setState(() => hideOld = !hideOld),
            ),
          ),
          const SizedBox(height: 14),

          TextField(
            controller: newController,
            obscureText: hideNew,
            enabled: !loading,
            decoration: _decoration(
              'New password',
              hideNew,
              () => setState(() => hideNew = !hideNew),
            ),
          ),
          const SizedBox(height: 14),

          TextField(
            controller: confirmController,
            obscureText: hideConfirm,
            enabled: !loading,
            onSubmitted: (_) => _save(),
            decoration: _decoration(
              'Confirm new password',
              hideConfirm,
              () => setState(() => hideConfirm = !hideConfirm),
            ),
          ),
          const SizedBox(height: 12),

          const Text(
            'Password must contain at least 6 characters.',
            style: TextStyle(
              fontSize: 11,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 24),

          ElevatedButton(
            onPressed: loading ? null : _save,
            child: loading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text('Update Password'),
          ),
        ],
      ),
    );
  }
}