import 'package:flutter/material.dart';

import '../services/profile_service.dart';

class PublicProfileScreen extends StatefulWidget {
  const PublicProfileScreen({
    super.key,
    required this.zyncupId,
  });

  final String zyncupId;

  @override
  State<PublicProfileScreen> createState() =>
      _PublicProfileScreenState();
}

class _PublicProfileScreenState extends State<PublicProfileScreen> {
  late Future<ZyncupProfile?> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture =
        ProfileService.getProfileByZyncupId(widget.zyncupId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<ZyncupProfile?>(
          future: _profileFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState ==
                ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              return const _ErrorState(
                message: 'Unable to load this ZYNCUP profile.',
              );
            }

            final profile = snapshot.data;

            if (profile == null) {
              return const _ErrorState(
                message: 'ZYNCUP profile not found.',
              );
            }

            return _ProfileContent(profile: profile);
          },
        ),
      ),
    );
  }
}

class _ProfileContent extends StatelessWidget {
  const _ProfileContent({
    required this.profile,
  });

  final ZyncupProfile profile;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final sharedItems = <_PublicInfoItem>[
      if (profile.shareInstagram &&
          _hasValue(profile.instagram))
        _PublicInfoItem(
          icon: Icons.camera_alt_outlined,
          label: 'Instagram',
          value: profile.instagram!,
        ),
      if (profile.shareLinkedin &&
          _hasValue(profile.linkedin))
        _PublicInfoItem(
          icon: Icons.business_center_outlined,
          label: 'LinkedIn',
          value: profile.linkedin!,
        ),
      if (profile.shareWebsite &&
          _hasValue(profile.website))
        _PublicInfoItem(
          icon: Icons.language_outlined,
          label: 'Website',
          value: profile.website!,
        ),
    ];

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 520,
          ),
          child: Column(
            children: [
              const SizedBox(height: 20),

              Text(
                'ZYNCUP',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2,
                ),
              ),

              const SizedBox(height: 28),

              CircleAvatar(
                radius: 56,
                backgroundImage:
                    profile.profileImageUrl != null &&
                            profile.profileImageUrl!.isNotEmpty
                        ? NetworkImage(
                            profile.profileImageUrl!,
                          )
                        : null,
                child: profile.profileImageUrl == null ||
                        profile.profileImageUrl!.isEmpty
                    ? Text(
                        profile.displayName.isNotEmpty
                            ? profile.displayName[0].toUpperCase()
                            : '?',
                        style: theme.textTheme.headlineMedium,
                      )
                    : null,
              ),

              const SizedBox(height: 18),

              Text(
                profile.displayName.isNotEmpty
                    ? profile.displayName
                    : 'ZYNCUP User',
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                profile.zyncupId,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),

              if (_hasValue(profile.bio)) ...[
                const SizedBox(height: 20),
                Text(
                  profile.bio!,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge,
                ),
              ],

              if (sharedItems.isNotEmpty) ...[
                const SizedBox(height: 28),
                Card(
                  child: Column(
                    children: [
                      for (var i = 0;
                          i < sharedItems.length;
                          i++) ...[
                        ListTile(
                          leading: Icon(sharedItems[i].icon),
                          title: Text(sharedItems[i].label),
                          subtitle: Text(sharedItems[i].value),
                        ),
                        if (i < sharedItems.length - 1)
                          const Divider(height: 1),
                      ],
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'The ZYNCUP app will handle the connection.',
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.person_add_alt_1),
                  label: const Text('Connect on ZYNCUP'),
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'ZYNCUP app installation coming next.',
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.download_outlined),
                  label: const Text('Get the ZYNCUP App'),
                ),
              ),

              const SizedBox(height: 12),

              TextButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Opening ZYNCUP app coming next.',
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.open_in_new),
                label: const Text(
                  'Already have ZYNCUP? Open the App',
                ),
              ),

              const SizedBox(height: 20),

              Text(
                'More Than Friends',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static bool _hasValue(String? value) {
    return value != null && value.trim().isNotEmpty;
  }
}

class _PublicInfoItem {
  const _PublicInfoItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({
    required this.message,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.person_off_outlined,
              size: 52,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
