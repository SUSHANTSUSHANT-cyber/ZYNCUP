import 'package:flutter/material.dart';

import '../services/profile_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    required this.profile,
    required this.onEdit,
    super.key,
  });

  final ZyncupProfile profile;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            tooltip: 'Edit profile',
            onPressed: onEdit,
            icon: const Icon(Icons.edit_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 620),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _ProfileHeader(profile: profile),
                  const SizedBox(height: 20),

                  if (_hasText(profile.bio)) ...[
                    _InfoCard(
                      icon: Icons.short_text,
                      title: 'About',
                      child: Text(
                        profile.bio!.trim(),
                        style: theme.textTheme.bodyLarge,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  _InfoCard(
                    icon: Icons.contact_page_outlined,
                    title: 'Contact',
                    child: Column(
                      children: [
                        _ProfileDetail(
                          icon: Icons.email_outlined,
                          label: 'Email',
                          value: profile.email,
                          shared: profile.shareEmail,
                        ),
                        _ProfileDetail(
                          icon: Icons.phone_outlined,
                          label: 'Phone',
                          value: profile.phone,
                          shared: profile.sharePhone,
                        ),
                        _ProfileDetail(
                          icon: Icons.language_outlined,
                          label: 'Website',
                          value: profile.website,
                          shared: profile.shareWebsite,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  _InfoCard(
                    icon: Icons.link_outlined,
                    title: 'Social',
                    child: Column(
                      children: [
                        _ProfileDetail(
                          icon: Icons.camera_alt_outlined,
                          label: 'Instagram',
                          value: profile.instagram,
                          shared: profile.shareInstagram,
                        ),
                        _ProfileDetail(
                          icon: Icons.work_outline,
                          label: 'LinkedIn',
                          value: profile.linkedin,
                          shared: profile.shareLinkedin,
                        ),
                        _ProfileDetail(
                          icon: Icons.public_outlined,
                          label: 'Other social',
                          value: profile.otherSocial,
                          shared: profile.shareOtherSocial,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  _ZyncupIdCard(zyncupId: profile.zyncupId),

                  const SizedBox(height: 24),

                  FilledButton.icon(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit_outlined),
                    label: const Text('Edit Profile'),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static bool _hasText(String? value) {
    return value != null && value.trim().isNotEmpty;
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({
    required this.profile,
  });

  final ZyncupProfile profile;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final hasImage = profile.profileImageUrl != null &&
        profile.profileImageUrl!.trim().isNotEmpty;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            CircleAvatar(
              radius: 46,
              backgroundColor: theme.colorScheme.primaryContainer,
              backgroundImage:
                  hasImage ? NetworkImage(profile.profileImageUrl!.trim()) : null,
              child: hasImage
                  ? null
                  : Icon(
                      Icons.person_outline,
                      size: 48,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
            ),
            const SizedBox(height: 16),
            Text(
              profile.displayName,
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                profile.zyncupId,
                style: theme.textTheme.labelLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.title,
    required this.child,
  });

  final IconData icon;
  final String title;
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
                Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            child,
          ],
        ),
      ),
    );
  }
}

class _ProfileDetail extends StatelessWidget {
  const _ProfileDetail({
    required this.icon,
    required this.label,
    required this.value,
    required this.shared,
  });

  final IconData icon;
  final String label;
  final String? value;
  final bool shared;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final hasValue = value != null && value!.trim().isNotEmpty;

    if (!hasValue) {
      return ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Icon(
          icon,
          color: theme.colorScheme.outline,
        ),
        title: Text(label),
        subtitle: const Text('Not added'),
      );
    }

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        icon,
        color: theme.colorScheme.primary,
      ),
      title: Text(label),
      subtitle: Text(value!.trim()),
      trailing: Tooltip(
        message: shared ? 'Shared with connections' : 'Private',
        child: Icon(
          shared
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined,
          color: shared
              ? theme.colorScheme.primary
              : theme.colorScheme.outline,
        ),
      ),
    );
  }
}

class _ZyncupIdCard extends StatelessWidget {
  const _ZyncupIdCard({
    required this.zyncupId,
  });

  final String zyncupId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Icon(
              Icons.badge_outlined,
              color: theme.colorScheme.primary,
              size: 30,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your ZYNCUP ID',
                    style: theme.textTheme.labelLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    zyncupId,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
