import 'package:flutter/material.dart';

import 'app_data.dart';
import 'app_theme.dart';
import 'auth_service.dart';
import 'home_page.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool hidePassword = true;
  bool rememberMe = true;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _loadRegisteredEmail();
  }

  Future<void> _loadRegisteredEmail() async {
    final hasAccount = await AuthService.hasRegisteredAccount();

    if (!hasAccount) return;

    final savedEmail = await AuthService.getUserEmail();

    if (mounted) {
      emailController.text = savedEmail;
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (!email.contains('@') || !email.contains('.')) {
      _showMessage('Please enter a valid email address.');
      return;
    }

    if (password.length < 6) {
      _showMessage('Password must contain at least 6 characters.');
      return;
    }

    final hasAccount = await AuthService.hasRegisteredAccount();

    if (!mounted) return;

    if (!hasAccount) {
      _showMessage('No account found. Please create an account first.');
      return;
    }

    setState(() => loading = true);

    final loginSuccessful = await AuthService.login(
      email: email,
      password: password,
      rememberMe: rememberMe,
    );

    if (!mounted) return;

    if (!loginSuccessful) {
      setState(() => loading = false);
      _showMessage('Incorrect email or password.');
      return;
    }

    // Load the saved account details for Home and Account pages.
    AppData.userName = await AuthService.getUserName();
    AppData.userEmail = await AuthService.getUserEmail();
    AppData.userPhone = await AuthService.getUserPhone();

    if (!mounted) return;

    setState(() => loading = false);

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const HomePage()),
      (route) => false,
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _showForgotPasswordMessage() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Forgot password'),
        content: const Text(
          'Password reset by email is not connected in this assessment prototype. '
          'After signing in, you can change your password from the Account section.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: AppTheme.primary,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.favorite_rounded,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 28),

                  const Text(
                    'Welcome back',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),

                  const Text(
                    'Sign in to manage your appointments and medication reminders.',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 32),

                  const Text(
                    'Email address',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),

                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    enabled: !loading,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.mail_outline_rounded),
                      hintText: 'name@example.com',
                    ),
                  ),
                  const SizedBox(height: 18),

                  const Text(
                    'Password',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),

                  TextField(
                    controller: passwordController,
                    obscureText: hidePassword,
                    enabled: !loading,
                    onSubmitted: (_) => _login(),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock_outline_rounded),
                      hintText: 'Enter your password',
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() => hidePassword = !hidePassword);
                        },
                        icon: Icon(
                          hidePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Checkbox(
                        value: rememberMe,
                        onChanged: loading
                            ? null
                            : (value) {
                                setState(
                                  () => rememberMe = value ?? false,
                                );
                              },
                      ),
                      const Text('Remember me'),
                      const Spacer(),
                      TextButton(
                        onPressed:
                            loading ? null : _showForgotPasswordMessage,
                        child: const Text('Forgot password?'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: loading ? null : _login,
                      child: loading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Sign In'),
                    ),
                  ),
                  const SizedBox(height: 22),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account? ",
                        style: TextStyle(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      TextButton(
                        onPressed: loading
                            ? null
                            : () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const RegisterPage(),
                                  ),
                                );
                              },
                        child: const Text('Create account'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  const Center(
                    child: Text(
                      'CareConnect assessment prototype',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}