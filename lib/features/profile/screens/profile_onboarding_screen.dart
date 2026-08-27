import 'package:flutter/material.dart';

import '../../auth/services/auth_service.dart';
import '../services/profile_service.dart';

class ProfileOnboardingScreen extends StatefulWidget {
  const ProfileOnboardingScreen({
    required this.profile,
    required this.onCompleted,
    super.key,
  });

  final ZyncupProfile profile;
  final VoidCallback onCompleted;

  @override
  State<ProfileOnboardingScreen> createState() =>
      _ProfileOnboardingScreenState();
}

class _ProfileOnboardingScreenState extends State<ProfileOnboardingScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _displayNameController;
  late final TextEditingController _bioController;

  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _websiteController;

  late final TextEditingController _instagramController;
  late final TextEditingController _linkedinController;
  late final TextEditingController _otherSocialController;

  late bool _sharePhone;
  late bool _shareEmail;
  late bool _shareWebsite;
  late bool _shareInstagram;
  late bool _shareLinkedin;
  late bool _shareOtherSocial;

  bool _isSaving = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    _displayNameController = TextEditingController(
      text: widget.profile.displayName == 'ZYNCUP User'
          ? ''
          : widget.profile.displayName,
    );

    _bioController = TextEditingController(
      text: widget.profile.bio ?? '',
    );

    _phoneController = TextEditingController(
      text: widget.profile.phone ?? '',
    );

    _emailController = TextEditingController(
      text: widget.profile.email ?? '',
    );

    _websiteController = TextEditingController(
      text: widget.profile.website ?? '',
    );

    _instagramController = TextEditingController(
      text: widget.profile.instagram ?? '',
    );

    _linkedinController = TextEditingController(
      text: widget.profile.linkedin ?? '',
    );

    _otherSocialController = TextEditingController(
      text: widget.profile.otherSocial ?? '',
    );

    _sharePhone = widget.profile.sharePhone;
    _shareEmail = widget.profile.shareEmail;
    _shareWebsite = widget.profile.shareWebsite;
    _shareInstagram = widget.profile.shareInstagram;
    _shareLinkedin = widget.profile.shareLinkedin;
    _shareOtherSocial = widget.profile.shareOtherSocial;
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _bioController.dispose();

    _phoneController.dispose();
    _emailController.dispose();
    _websiteController.dispose();

    _instagramController.dispose();
    _linkedinController.dispose();
    _otherSocialController.dispose();

    super.dispose();
  }

  Future<void> _save() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    final user = AuthService.currentUser;

    if (user == null) {
      _setError('You are no longer signed in. Please log in again.');
      return;
    }

    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    try {
      await ProfileService.completeProfile(
        userId: user.id,
        displayName: _displayNameController.text.trim(),
        bio: _bioController.text.trim(),

        phone: _phoneController.text.trim(),
        email: _emailController.text.trim(),
        website: _websiteController.text.trim(),

        instagram: _instagramController.text.trim(),
        linkedin: _linkedinController.text.trim(),
        otherSocial: _otherSocialController.text.trim(),

        sharePhone:
            _phoneController.text.trim().isNotEmpty && _sharePhone,

        shareEmail:
            _emailController.text.trim().isNotEmpty && _shareEmail,

        shareWebsite:
            _websiteController.text.trim().isNotEmpty && _shareWebsite,

        shareInstagram:
            _instagramController.text.trim().isNotEmpty &&
            _shareInstagram,

        shareLinkedin:
            _linkedinController.text.trim().isNotEmpty &&
            _shareLinkedin,

        shareOtherSocial:
            _otherSocialController.text.trim().isNotEmpty &&
            _shareOtherSocial,
      );

      if (!mounted) return;

      widget.onCompleted();
    } catch (error, stackTrace) {
      debugPrint('');
      debugPrint('========== PROFILE SAVE ERROR ==========');
      debugPrint('Error type: ${error.runtimeType}');
      debugPrint('Error: $error');
      debugPrintStack(stackTrace: stackTrace);
      debugPrint('========================================');
      debugPrint('');

      if (!mounted) return;

      _setError('Profile save failed: $error');
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  void _setError(String message) {
    if (!mounted) return;

    setState(() {
      _errorMessage = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete your profile'),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 620),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _SectionCard(
                      icon: Icons.person_outline,
                      title: 'About you',
                      subtitle:
                          'Add the details people will know you by.',
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _displayNameController,
                            enabled: !_isSaving,
                            textCapitalization:
                                TextCapitalization.words,
                            maxLength: 80,
                            decoration: const InputDecoration(
                              labelText: 'Display name',
                              hintText:
                                  'What should people call you?',
                              prefixIcon:
                                  Icon(Icons.person_outline),
                            ),
                            validator: _validateDisplayName,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _bioController,
                            enabled: !_isSaving,
                            minLines: 3,
                            maxLines: 5,
                            maxLength: 500,
                            decoration: const InputDecoration(
                              labelText: 'Bio (optional)',
                              hintText: 'A little about you...',
                              alignLabelWithHint: true,
                              prefixIcon:
                                  Icon(Icons.short_text),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    _SectionCard(
                      icon: Icons.contact_page_outlined,
                      title: 'Contact details',
                      subtitle:
                          'You decide what information is shared.',
                      child: Column(
                        children: [
                          _ShareField(
                            controller: _emailController,
                            label: 'Email',
                            hintText: 'you@example.com',
                            icon: Icons.email_outlined,
                            keyboardType:
                                TextInputType.emailAddress,
                            value: _shareEmail,
                            enabled: !_isSaving,
                            onChanged: (value) {
                              setState(() {
                                _shareEmail = value;
                              });
                            },
                          ),
                          _ShareField(
                            controller: _phoneController,
                            label: 'Phone',
                            hintText: 'Your phone number',
                            icon: Icons.phone_outlined,
                            keyboardType: TextInputType.phone,
                            value: _sharePhone,
                            enabled: !_isSaving,
                            onChanged: (value) {
                              setState(() {
                                _sharePhone = value;
                              });
                            },
                          ),
                          _ShareField(
                            controller: _websiteController,
                            label: 'Website',
                            hintText:
                                'https://yourwebsite.com',
                            icon: Icons.language_outlined,
                            keyboardType:
                                TextInputType.url,
                            value: _shareWebsite,
                            enabled: !_isSaving,
                            onChanged: (value) {
                              setState(() {
                                _shareWebsite = value;
                              });
                            },
                            isLast: true,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    _SectionCard(
                      icon: Icons.link_outlined,
                      title: 'Social links',
                      subtitle:
                          'Add places where your connections can find you.',
                      child: Column(
                        children: [
                          _ShareField(
                            controller: _instagramController,
                            label: 'Instagram',
                            hintText:
                                'instagram.com/yourusername',
                            icon: Icons.camera_alt_outlined,
                            value: _shareInstagram,
                            enabled: !_isSaving,
                            onChanged: (value) {
                              setState(() {
                                _shareInstagram = value;
                              });
                            },
                          ),
                          _ShareField(
                            controller: _linkedinController,
                            label: 'LinkedIn',
                            hintText:
                                'linkedin.com/in/yourname',
                            icon: Icons.work_outline,
                            value: _shareLinkedin,
                            enabled: !_isSaving,
                            onChanged: (value) {
                              setState(() {
                                _shareLinkedin = value;
                              });
                            },
                          ),
                          _ShareField(
                            controller: _otherSocialController,
                            label: 'Other social',
                            hintText:
                                'Any other social or profile link',
                            icon: Icons.public_outlined,
                            value: _shareOtherSocial,
                            enabled: !_isSaving,
                            onChanged: (value) {
                              setState(() {
                                _shareOtherSocial = value;
                              });
                            },
                            isLast: true,
                          ),
                        ],
                      ),
                    ),

                    if (_errorMessage != null) ...[
                      const SizedBox(height: 16),
                      _ErrorNotice(
                        message: _errorMessage!,
                      ),
                    ],

                    const SizedBox(height: 20),

                    FilledButton.icon(
                      onPressed: _isSaving ? null : _save,
                      icon: _isSaving
                          ? const SizedBox.square(
                              dimension: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(
                              Icons.arrow_forward,
                            ),
                      label: Text(
                        _isSaving
                            ? 'Saving...'
                            : 'Continue to ZYNCUP',
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      'You can change these details and sharing preferences anytime.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleLarge,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            child,
          ],
        ),
      ),
    );
  }
}

class _ShareField extends StatelessWidget {
  const _ShareField({
    required this.controller,
    required this.label,
    required this.hintText,
    required this.icon,
    required this.value,
    required this.enabled,
    required this.onChanged,
    this.keyboardType,
    this.isLast = false,
  });

  final TextEditingController controller;
  final String label;
  final String hintText;
  final IconData icon;
  final bool value;
  final bool enabled;
  final ValueChanged<bool> onChanged;
  final TextInputType? keyboardType;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: controller,
          enabled: enabled,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            labelText: label,
            hintText: hintText,
            prefixIcon: Icon(icon),
          ),
        ),
        SwitchListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 4),
          title: const Text('Share with connections'),
          subtitle: Text(
            value
                ? 'This detail will be visible to your connections.'
                : 'This detail is currently private.',
          ),
          value: value,
          onChanged: enabled ? onChanged : null,
        ),
        if (!isLast) const Divider(height: 28),
      ],
    );
  }
}

String? _validateDisplayName(String? value) {
  final displayName = value?.trim() ?? '';

  if (displayName.isEmpty) {
    return 'Display name is required.';
  }

  if (displayName == 'ZYNCUP User') {
    return 'Choose your own display name.';
  }

  if (displayName.length > 80) {
    return 'Display name must be 80 characters or fewer.';
  }

  return null;
}

class _ErrorNotice extends StatelessWidget {
  const _ErrorNotice({
    required this.message,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    final error = Theme.of(context).colorScheme.error;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: error.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: error.withValues(alpha: 0.35),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Text(
          message,
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: error),
        ),
      ),
    );
  }
}