import 'package:flutter/material.dart';

import '../../auth/services/auth_service.dart';
import '../../profile/services/profile_service.dart';
import '../services/connection_service.dart';

class ConnectionsScreen extends StatefulWidget {
  const ConnectionsScreen({super.key});

  @override
  State<ConnectionsScreen> createState() => _ConnectionsScreenState();
}

class _ConnectionsScreenState extends State<ConnectionsScreen> {
  bool _loading = true;
  String? _error;

  List<Map<String, dynamic>> _pending = [];
  List<Map<String, dynamic>> _accepted = [];

  @override
  void initState() {
    super.initState();
    _loadConnections();
  }

  Future<void> _loadConnections() async {
    final user = AuthService.currentUser;

    if (user == null) {
      if (!mounted) return;

      setState(() {
        _loading = false;
        _error = 'Please log in to view your connections.';
      });
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      debugPrint('ZYNCUP: Current user = ${user.id}');

      final pending =
          await ConnectionService.getPendingRequests(user.id);

      debugPrint(
        'ZYNCUP: Pending connections = ${pending.length}',
      );

      final accepted =
          await ConnectionService.getAcceptedConnections(user.id);

      debugPrint(
        'ZYNCUP: Accepted connections = ${accepted.length}',
      );

      for (final connection in accepted) {
        debugPrint(
          'ZYNCUP: Connection = '
          '${connection['requester_id']} -> '
          '${connection['receiver_id']} '
          'status=${connection['status']}',
        );
      }

      if (!mounted) return;

      setState(() {
        _pending = pending;
        _accepted = accepted;
        _loading = false;
      });
    } catch (error) {
      debugPrint('ZYNCUP: Connections error = $error');

      if (!mounted) return;

      setState(() {
        _loading = false;
        _error = 'Unable to load your connections.';
      });
    }
  }

  Future<void> _accept(String connectionId) async {
    try {
      await ConnectionService.acceptRequest(
        connectionId: connectionId,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Connection accepted.'),
        ),
      );

      await _loadConnections();
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Unable to accept the request. Please try again.',
          ),
        ),
      );
    }
  }

  Future<void> _reject(String connectionId) async {
    try {
      await ConnectionService.rejectRequest(
        connectionId: connectionId,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Connection request rejected.'),
        ),
      );

      await _loadConnections();
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Unable to reject the request. Please try again.',
          ),
        ),
      );
    }
  }

  Future<ZyncupProfile?> _profile(String userId) {
    return ProfileService.getProfile(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connections'),
      ),
      body: RefreshIndicator(
        onRefresh: _loadConnections,
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return ListView(
        physics: AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: 250),
          Center(
            child: CircularProgressIndicator(),
          ),
        ],
      );
    }

    if (_error != null) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          const SizedBox(height: 150),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Icon(
                    Icons.cloud_off_outlined,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _error!,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: _loadConnections,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Try again'),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    if (_pending.isEmpty && _accepted.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: const [
          SizedBox(height: 150),
          Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                children: [
                  Icon(
                    Icons.people_outline,
                    size: 56,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No connections yet.',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Scan a ZYNCUP QR code to connect with someone.',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      children: [
        if (_pending.isNotEmpty) ...[
          _SectionHeader(
            title: 'Pending Requests',
            count: _pending.length,
          ),
          const SizedBox(height: 8),
          ..._pending.map(
            (request) => _PendingRequestCard(
              request: request,
              loadProfile: _profile,
              onAccept: _accept,
              onReject: _reject,
            ),
          ),
          const SizedBox(height: 24),
        ],
        if (_accepted.isNotEmpty) ...[
          _SectionHeader(
            title: 'Your Connections',
            count: _accepted.length,
          ),
          const SizedBox(height: 8),
          ..._accepted.map(
            (connection) => _AcceptedConnectionCard(
              connection: connection,
              currentUserId: AuthService.currentUser!.id,
              loadProfile: _profile,
            ),
          ),
        ],
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.count,
  });

  final String title;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(width: 8),
        CircleAvatar(
          radius: 12,
          child: Text(
            '$count',
            style: const TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }
}

class _PendingRequestCard extends StatelessWidget {
  const _PendingRequestCard({
    required this.request,
    required this.loadProfile,
    required this.onAccept,
    required this.onReject,
  });

  final Map<String, dynamic> request;
  final Future<ZyncupProfile?> Function(String) loadProfile;
  final Future<void> Function(String) onAccept;
  final Future<void> Function(String) onReject;

  @override
  Widget build(BuildContext context) {
    final requesterId = request['requester_id'] as String;
    final connectionId = request['id'] as String;

    return FutureBuilder<ZyncupProfile?>(
      future: loadProfile(requesterId),
      builder: (context, snapshot) {
        final profile = snapshot.data;

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    radius: 28,
                    backgroundImage:
                        profile?.profileImageUrl != null &&
                                profile!.profileImageUrl!.isNotEmpty
                            ? NetworkImage(
                                profile.profileImageUrl!,
                              )
                            : null,
                    child: profile == null
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : profile.profileImageUrl == null ||
                                profile.profileImageUrl!.isEmpty
                            ? Text(
                                profile.displayName.isNotEmpty
                                    ? profile.displayName[0]
                                        .toUpperCase()
                                    : '?',
                              )
                            : null,
                  ),
                  title: Text(
                    profile?.displayName ?? 'Loading...',
                  ),
                  subtitle: Text(
                    profile?.zyncupId ?? '',
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => onReject(connectionId),
                        child: const Text('Reject'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: () => onAccept(connectionId),
                        child: const Text('Accept'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _AcceptedConnectionCard extends StatelessWidget {
  const _AcceptedConnectionCard({
    required this.connection,
    required this.currentUserId,
    required this.loadProfile,
  });

  final Map<String, dynamic> connection;
  final String currentUserId;
  final Future<ZyncupProfile?> Function(String) loadProfile;

  @override
  Widget build(BuildContext context) {
    final requesterId = connection['requester_id'] as String;
    final receiverId = connection['receiver_id'] as String;

    final otherUserId =
        requesterId == currentUserId ? receiverId : requesterId;

    return FutureBuilder<ZyncupProfile?>(
      future: loadProfile(otherUserId),
      builder: (context, snapshot) {
        final profile = snapshot.data;

        return Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage:
                  profile?.profileImageUrl != null &&
                          profile!.profileImageUrl!.isNotEmpty
                      ? NetworkImage(profile.profileImageUrl!)
                      : null,
              child: profile == null
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                  : profile.profileImageUrl == null ||
                          profile.profileImageUrl!.isEmpty
                      ? Text(
                          profile.displayName.isNotEmpty
                              ? profile.displayName[0].toUpperCase()
                              : '?',
                        )
                      : null,
            ),
            title: Text(
              profile?.displayName ?? 'Loading...',
            ),
            subtitle: Text(
              profile?.zyncupId ?? '',
            ),
            trailing: const Icon(
              Icons.check_circle_outline,
            ),
          ),
        );
      },
    );
  }
}

