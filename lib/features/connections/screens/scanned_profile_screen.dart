import 'package:flutter/material.dart';

import '../../auth/services/auth_service.dart';
import '../services/connection_service.dart';
import '../../profile/services/profile_service.dart';

class ScannedProfileScreen extends StatefulWidget {
  const ScannedProfileScreen({
    required this.profile,
    super.key,
  });

  final ZyncupProfile profile;

  @override
  State<ScannedProfileScreen> createState() => _ScannedProfileScreenState();
}

class _ScannedProfileScreenState extends State<ScannedProfileScreen> {
  bool _isSending = false;
  bool _requestSent = false;
  String? _connectionStatus;

  @override
  void initState() {
    super.initState();
    _loadConnectionStatus();
  }

  Future<void> _loadConnectionStatus() async {
    final currentUser = AuthService.currentUser;

    if (currentUser == null) return;

    if (currentUser.id == widget.profile.id) {
      return;
    }

    try {
      final status = await ConnectionService.getConnectionStatus(
        currentUserId: currentUser.id,
        otherUserId: widget.profile.id,
      );

      if (!mounted) return;

      setState(() {
        _connectionStatus = status;
        _requestSent = status == 'pending';
      });
    } catch (_) {
      // The profile itself remains usable even if connection status
      // cannot be loaded.
    }
  }

  Future<void> _sendConnectionRequest() async {
    final currentUser = AuthService.currentUser;

    if (currentUser == null) {
      _showMessage('You need to be logged in to connect.');
      return;
    }

    if (currentUser.id == widget.profile.id) {
      _showMessage('This is your own profile.');
      return;
    }

    setState(() {
      _isSending = true;
    });

    try {
      await ConnectionService.sendRequest(
        requesterId: currentUser.id,
        receiverId: widget.profile.id,
      );

      if (!mounted) return;

      setState(() {
        _isSending = false;
        _requestSent = true;
        _connectionStatus = 'pending';
      });

      _showMessage('Connection request sent.');
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _isSending = false;
      });

      _showMessage(
        _friendlyConnectionError(error),
      );
    }
  }

  String _friendlyConnectionError(Object error) {
    final message = error.toString();

    if (message.contains('already exists')) {
      return 'A connection request already exists.';
    }

    if (message.contains('cannot connect with yourself')) {
      return 'You cannot connect with yourself.';
    }

    return 'Unable to send connection request. Please try again.';
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  Widget _buildConnectionButton(BuildContext context) {
    final currentUser = AuthService.currentUser;

    if (currentUser?.id == widget.profile.id) {
      return OutlinedButton.icon(
        onPressed: null,
        icon: const Icon(Icons.person),
        label: const Text('Your Profile'),
      );
    }

    if (_connectionStatus == 'accepted') {
      return FilledButton.icon(
        onPressed: null,
        icon: const Icon(Icons.check),
        label: const Text('Connected'),
      );
    }

    if (_connectionStatus == 'pending' || _requestSent) {
      return OutlinedButton.icon(
        onPressed: null,
        icon: const Icon(Icons.schedule),
        label: const Text('Request Sent'),
      );
    }

    if (_connectionStatus == 'rejected') {
      return FilledButton.icon(
        onPressed: _isSending ? null : _sendConnectionRequest,
        icon: _isSending
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              )
            : const Icon(Icons.person_add_alt_1),
        label: const Text('Connect Again'),
      );
    }

    return FilledButton.icon(
      onPressed: _isSending ? null : _sendConnectionRequest,
      icon: _isSending
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            )
          : const Icon(Icons.person_add_alt_1),
      label: Text(
        _isSending ? 'Sending...' : 'Connect',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final profile = widget.profile;

    return Scaffold(
      appBar: AppBar(
        title: const Text('ZYNCUP Profile'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 600,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),

                  CircleAvatar(
                    radius: 48,
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
                            style: theme.textTheme.headlineMedium,
                          )
                        : null,
                  ),

                  const SizedBox(height: 16),

                  Text(
                    profile.displayName,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
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

                  if (profile.bio != null &&
                      profile.bio!.trim().isNotEmpty) ...[
                    const SizedBox(height: 20),
                    Card(
                      elevation: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Text(
                          profile.bio!,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyLarge,
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 20),

                  _SharedInformation(
                    profile: profile,
                  ),

                  const SizedBox(height: 28),

                  _buildConnectionButton(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SharedInformation extends StatelessWidget {
  const _SharedInformation({
    required this.profile,
  });

  final ZyncupProfile profile;

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      if (profile.shareInstagram &&
          _hasValue(profile.instagram))
        _InfoTile(
          icon: Icons.camera_alt_outlined,
          label: 'Instagram',
          value: profile.instagram!,
        ),

      if (profile.shareLinkedin &&
          _hasValue(profile.linkedin))
        _InfoTile(
          icon: Icons.work_outline,
          label: 'LinkedIn',
          value: profile.linkedin!,
        ),

      if (profile.shareWebsite &&
          _hasValue(profile.website))
        _InfoTile(
          icon: Icons.language_outlined,
          label: 'Website',
          value: profile.website!,
        ),

      if (profile.sharePhone &&
          _hasValue(profile.phone))
        _InfoTile(
          icon: Icons.phone_outlined,
          label: 'Phone',
          value: profile.phone!,
        ),

      if (profile.shareEmail &&
          _hasValue(profile.email))
        _InfoTile(
          icon: Icons.email_outlined,
          label: 'Email',
          value: profile.email!,
        ),

      if (profile.shareOtherSocial &&
          _hasValue(profile.otherSocial))
        _InfoTile(
          icon: Icons.public_outlined,
          label: 'Other',
          value: profile.otherSocial!,
        ),
    ];

    if (items.isEmpty) {
      return Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Icon(
                Icons.lock_outline,
                size: 32,
                color: Theme.of(context)
                    .colorScheme
                    .onSurfaceVariant,
              ),
              const SizedBox(height: 8),
              Text(
                'No contact or social details shared.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: items,
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(context).colorScheme.primary,
      ),
      title: Text(label),
      subtitle: Text(value),
    );
  }
}

bool _hasValue(String? value) {
  return value != null && value.trim().isNotEmpty;
}
