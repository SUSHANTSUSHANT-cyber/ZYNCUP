import 'package:flutter/material.dart';

import '../../profile/services/profile_service.dart';

class ConnectedProfileScreen extends StatelessWidget {
  const ConnectedProfileScreen({
    super.key,
    required this.profile,
  });

  final ZyncupProfile profile;

  @override
  Widget build(BuildContext context) {
    final sharedContactFields = <_ProfileField>[
      if (profile.sharePhone &&
          _hasValue(profile.phone))
        _ProfileField(
          icon: Icons.phone_outlined,
          label: 'Phone',
          value: profile.phone!,
        ),
      if (profile.shareEmail &&
          _hasValue(profile.email))
        _ProfileField(
          icon: Icons.email_outlined,
          label: 'Email',
          value: profile.email!,
        ),
      if (profile.shareWebsite &&
          _hasValue(profile.website))
        _ProfileField(
          icon: Icons.language_outlined,
          label: 'Website',
          value: profile.website!,
        ),
      if (profile.shareInstagram &&
          _hasValue(profile.instagram))
        _ProfileField(
          icon: Icons.camera_alt_outlined,
          label: 'Instagram',
          value: profile.instagram!,
        ),
      if (profile.shareLinkedin &&
          _hasValue(profile.linkedin))
        _ProfileField(
          icon: Icons.business_center_outlined,
          label: 'LinkedIn',
          value: profile.linkedin!,
        ),
      if (profile.shareOtherSocial &&
          _hasValue(profile.otherSocial))
        _ProfileField(
          icon: Icons.share_outlined,
          label: 'Other',
          value: profile.otherSocial!,
        ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Connection'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 8),

          Center(
            child: CircleAvatar(
              radius: 52,
              backgroundImage:
                  profile.profileImageUrl != null &&
                          profile.profileImageUrl!.isNotEmpty
                      ? NetworkImage(profile.profileImageUrl!)
                      : null,
              child: profile.profileImageUrl == null ||
                      profile.profileImageUrl!.isEmpty
                  ? Text(
                      profile.displayName.isNotEmpty
                          ? profile.displayName[0].toUpperCase()
                          : '?',
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  : null,
            ),
          ),

          const SizedBox(height: 16),

          Center(
            child: Text(
              profile.displayName.isNotEmpty
                  ? profile.displayName
                  : 'ZYNCUP User',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 6),

          Center(
            child: Text(
              profile.zyncupId,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurfaceVariant,
                  ),
            ),
          ),

          if (_hasValue(profile.bio)) ...[
            const SizedBox(height: 24),
            _SectionTitle(
              title: 'About',
              icon: Icons.person_outline,
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  profile.bio!,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge,
                ),
              ),
            ),
          ],

          const SizedBox(height: 24),

          _SectionTitle(
            title: 'Shared Contact & Socials',
            icon: Icons.contact_page_outlined,
          ),

          const SizedBox(height: 8),

          if (sharedContactFields.isEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Icon(
                      Icons.visibility_off_outlined,
                      size: 40,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurfaceVariant,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'No contact or social information shared.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge,
                    ),
                  ],
                ),
              ),
            )
          else
            Card(
              child: Column(
                children: [
                  for (var i = 0;
                      i < sharedContactFields.length;
                      i++) ...[
                    _ContactTile(
                      field: sharedContactFields[i],
                    ),
                    if (i < sharedContactFields.length - 1)
                      const Divider(height: 1),
                  ],
                ],
              ),
            ),

          const SizedBox(height: 24),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.lock_outline,
                    color: Theme.of(context)
                        .colorScheme
                        .primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'You can only see the contact and social information this person has chosen to share.',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static bool _hasValue(String? value) {
    return value != null && value.trim().isNotEmpty;
  }
}

class _ProfileField {
  const _ProfileField({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.title,
    required this.icon,
  });

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 22),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
      ],
    );
  }
}

class _ContactTile extends StatelessWidget {
  const _ContactTile({
    required this.field,
  });

  final _ProfileField field;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(field.icon),
      title: Text(
        field.label,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(field.value),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 6,
      ),
    );
  }
}