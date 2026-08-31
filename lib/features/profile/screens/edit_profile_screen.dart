import 'package:flutter/material.dart';

import '../services/profile_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({
    required this.profile,
    required this.onSaved,
    super.key,
  });

  final ZyncupProfile profile;
  final VoidCallback onSaved;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _displayNameController;
  late final TextEditingController _bioController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _websiteController;
  late final TextEditingController _instagramController;
  late final TextEditingController _linkedinController;
  late final TextEditingController _otherSocialController;

  late bool _shareEmail;
  late bool _sharePhone;
  late bool _shareWebsite;
  late bool _shareInstagram;
  late bool _shareLinkedin;
  late bool _shareOtherSocial;

  bool _isSaving = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    final profile = widget.profile;

    _displayNameController =
        TextEditingController(text: profile.displayName);
    _bioController = TextEditingController(text: profile.bio ?? '');

    _emailController =
        TextEditingController(text: profile.email ?? '');
    _phoneController =
        TextEditingController(text: profile.phone ?? '');
    _websiteController =
        TextEditingController(text: profile.website ?? '');

    _instagramController =
        TextEditingController(text: profile.instagram ?? '');
    _linkedinController =
        TextEditingController(text: profile.linkedin ?? '');
    _otherSocialController =
        TextEditingController(text: profile.otherSocial ?? '');

    _shareEmail = profile.shareEmail;
    _sharePhone = profile.sharePhone;
    _shareWebsite = profile.shareWebsite;
    _shareInstagram = profile.shareInstagram;
    _shareLinkedin = profile.shareLinkedin;
    _shareOtherSocial = profile.shareOtherSocial;
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _bioController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _websiteController.dispose();
    _instagramController.dispose();
    _linkedinController.dispose();
    _otherSocialController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    try {
      await ProfileService.updateProfile(
        userId: widget.profile.id,
        displayName: _displayNameController.text,
        bio: _bioController.text,

        email: _emailController.text,
        phone: _phoneController.text,
        website: _websiteController.text,

        instagram: _instagramController.text,
        linkedin: _linkedinController.text,
        otherSocial: _otherSocialController.text,

        shareEmail:
            _emailController.text.trim().isNotEmpty && _shareEmail,

        sharePhone:
            _phoneController.text.trim().isNotEmpty && _sharePhone,

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

      widget.onSaved();
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _errorMessage = 'Unable to save your profile: $error';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  void _handleFieldChanged({
    required String value,
    required VoidCallback disableSharing,
  }) {
    if (value.trim().isEmpty) {
      disableSharing();
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 620),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _displayNameController,
                      enabled: !_isSaving,
                      textCapitalization: TextCapitalization.words,
                      maxLength: 80,
                      decoration: const InputDecoration(
                        labelText: 'Display name',
                        prefixIcon: Icon(Icons.person_outline),
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
                        labelText: 'Bio',
                        prefixIcon: Icon(Icons.short_text),
                        alignLabelWithHint: true,
                      ),
                    ),

                    const SizedBox(height: 24),

                    _SectionTitle(
                      icon: Icons.contact_page_outlined,
                      title: 'Contact',
                    ),

                    _EditableField(
                      controller: _emailController,
                      label: 'Email',
                      icon: Icons.email_outlined,
                      enabled: !_isSaving,
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) {
                        _handleFieldChanged(
                          value: value,
                          disableSharing: () => _shareEmail = false,
                        );
                      },
                    ),

                    _ShareSwitch(
                      label: 'Share email with connections',
                      value: _shareEmail,
                      enabled:
                          !_isSaving &&
                          _emailController.text.trim().isNotEmpty,
                      onChanged: (value) {
                        setState(() => _shareEmail = value);
                      },
                    ),

                    _EditableField(
                      controller: _phoneController,
                      label: 'Phone',
                      icon: Icons.phone_outlined,
                      enabled: !_isSaving,
                      keyboardType: TextInputType.phone,
                      onChanged: (value) {
                        _handleFieldChanged(
                          value: value,
                          disableSharing: () => _sharePhone = false,
                        );
                      },
                    ),

                    _ShareSwitch(
                      label: 'Share phone with connections',
                      value: _sharePhone,
                      enabled:
                          !_isSaving &&
                          _phoneController.text.trim().isNotEmpty,
                      onChanged: (value) {
                        setState(() => _sharePhone = value);
                      },
                    ),

                    _EditableField(
                      controller: _websiteController,
                      label: 'Website',
                      icon: Icons.language_outlined,
                      enabled: !_isSaving,
                      keyboardType: TextInputType.url,
                      onChanged: (value) {
                        _handleFieldChanged(
                          value: value,
                          disableSharing: () => _shareWebsite = false,
                        );
                      },
                    ),

                    _ShareSwitch(
                      label: 'Share website with connections',
                      value: _shareWebsite,
                      enabled:
                          !_isSaving &&
                          _websiteController.text.trim().isNotEmpty,
                      onChanged: (value) {
                        setState(() => _shareWebsite = value);
                      },
                    ),

                    const SizedBox(height: 24),

                    _SectionTitle(
                      icon: Icons.link_outlined,
                      title: 'Social',
                    ),

                    _EditableField(
                      controller: _instagramController,
                      label: 'Instagram',
                      icon: Icons.camera_alt_outlined,
                      enabled: !_isSaving,
                      onChanged: (value) {
                        _handleFieldChanged(
                          value: value,
                          disableSharing: () => _shareInstagram = false,
                        );
                      },
                    ),

                    _ShareSwitch(
                      label: 'Share Instagram with connections',
                      value: _shareInstagram,
                      enabled:
                          !_isSaving &&
                          _instagramController.text.trim().isNotEmpty,
                      onChanged: (value) {
                        setState(() => _shareInstagram = value);
                      },
                    ),

                    _EditableField(
                      controller: _linkedinController,
                      label: 'LinkedIn',
                      icon: Icons.work_outline,
                      enabled: !_isSaving,
                      onChanged: (value) {
                        _handleFieldChanged(
                          value: value,
                          disableSharing: () => _shareLinkedin = false,
                        );
                      },
                    ),

                    _ShareSwitch(
                      label: 'Share LinkedIn with connections',
                      value: _shareLinkedin,
                      enabled:
                          !_isSaving &&
                          _linkedinController.text.trim().isNotEmpty,
                      onChanged: (value) {
                        setState(() => _shareLinkedin = value);
                      },
                    ),

                    _EditableField(
                      controller: _otherSocialController,
                      label: 'Other social',
                      icon: Icons.public_outlined,
                      enabled: !_isSaving,
                      onChanged: (value) {
                        _handleFieldChanged(
                          value: value,
                          disableSharing: () => _shareOtherSocial = false,
                        );
                      },
                    ),

                    _ShareSwitch(
                      label: 'Share other social with connections',
                      value: _shareOtherSocial,
                      enabled:
                          !_isSaving &&
                          _otherSocialController.text.trim().isNotEmpty,
                      onChanged: (value) {
                        setState(() => _shareOtherSocial = value);
                      },
                    ),

                    if (_errorMessage != null) ...[
                      const SizedBox(height: 16),
                      Text(
                        _errorMessage!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ],

                    const SizedBox(height: 24),

                    FilledButton.icon(
                      onPressed: _isSaving ? null : _save,
                      icon: _isSaving
                          ? const SizedBox.square(
                              dimension: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(Icons.save_outlined),
                      label: Text(
                        _isSaving ? 'Saving...' : 'Save Changes',
                      ),
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

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.icon,
    required this.title,
  });

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            icon,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _EditableField extends StatelessWidget {
  const _EditableField({
    required this.controller,
    required this.label,
    required this.icon,
    required this.enabled,
    required this.onChanged,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool enabled;
  final ValueChanged<String> onChanged;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        keyboardType: keyboardType,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
        ),
      ),
    );
  }
}

class _ShareSwitch extends StatelessWidget {
  const _ShareSwitch({
    required this.label,
    required this.value,
    required this.enabled,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final bool enabled;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      value: value,
      onChanged: enabled ? onChanged : null,
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
