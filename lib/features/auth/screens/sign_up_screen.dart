import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/routes/app_router.dart';
import '../../../services/supabase_service.dart';
import '../services/auth_service.dart';
import '../widgets/auth_panel.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  var _isLoading = false;
  String? _message;
  bool _isError = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _message = null;
      _isError = false;
    });

    try {
      final response = await AuthService.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (!mounted) return;
      if (response.session == null) {
        setState(() {
          _message = 'Account created. Check your email to confirm your address, then log in.';
          _isError = false;
        });
      }
    } on AuthException catch (error) {
      _setMessage(error.message, isError: true);
    } catch (_) {
      _setMessage(
        'Unable to create your account right now. Please try again.',
        isError: true,
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _setMessage(String message, {required bool isError}) {
    if (!mounted) return;
    setState(() {
      _message = message;
      _isError = isError;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AuthPanel(
      title: 'Create your circle',
      subtitle: 'Start with a private identity. The profile, QR, and connections come next.',
      children: [
        if (!SupabaseService.isConfigured) ...[
          const _AuthNotice(
            message: 'Supabase credentials are missing. Add the public URL and publishable key as Dart defines before sign up.',
          ),
          const SizedBox(height: 16),
        ],
        if (_message != null) ...[
          _AuthNotice(message: _message!, isError: _isError),
          const SizedBox(height: 16),
        ],
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _emailController,
                enabled: !_isLoading,
                keyboardType: TextInputType.emailAddress,
                autofillHints: const [AutofillHints.email],
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.alternate_email),
                ),
                validator: _validateEmail,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _passwordController,
                enabled: !_isLoading,
                obscureText: true,
                autofillHints: const [AutofillHints.newPassword],
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
                validator: _validatePassword,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _confirmPasswordController,
                enabled: !_isLoading,
                obscureText: true,
                autofillHints: const [AutofillHints.newPassword],
                decoration: const InputDecoration(
                  labelText: 'Confirm password',
                  prefixIcon: Icon(Icons.verified_user_outlined),
                ),
                validator: (value) =>
                    _validateConfirmPassword(value, _passwordController.text),
                onFieldSubmitted: (_) => _isLoading ? null : _submit(),
              ),
              const SizedBox(height: 22),
              FilledButton.icon(
                onPressed: _isLoading ? null : _submit,
                icon: _isLoading
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.person_add_alt_1),
                label: Text(_isLoading ? 'Creating account...' : 'Sign Up'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        TextButton(
          onPressed: _isLoading
              ? null
              : () =>
                    Navigator.of(context).pushReplacementNamed(AppRoutes.login),
          child: const Text('Already have an account? Login'),
        ),
      ],
    );
  }
}

class _AuthNotice extends StatelessWidget {
  const _AuthNotice({required this.message, this.isError = false});

  final String message;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final color = isError ? colorScheme.error : colorScheme.primary;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.32)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Text(
          message,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: color),
        ),
      ),
    );
  }
}

String? _validateEmail(String? value) {
  final email = value?.trim() ?? '';
  final isValid = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
  if (email.isEmpty) return 'Email is required.';
  if (!isValid) return 'Enter a valid email address.';
  return null;
}

String? _validatePassword(String? value) {
  final password = value ?? '';
  if (password.isEmpty) return 'Password is required.';
  if (password.length < 6) return 'Password must be at least 6 characters.';
  return null;
}

String? _validateConfirmPassword(String? value, String password) {
  final confirmation = value ?? '';
  if (confirmation.isEmpty) return 'Confirm your password.';
  if (confirmation != password) return 'Passwords do not match.';
  return null;
}
