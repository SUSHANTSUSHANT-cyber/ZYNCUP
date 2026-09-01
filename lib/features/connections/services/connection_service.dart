import '../../../services/supabase_service.dart';

class ConnectionService {
  ConnectionService._();

  static Future<Map<String, dynamic>?> getConnection({
    required String currentUserId,
    required String otherUserId,
  }) async {
    final data = await SupabaseService.client
        .from('connections')
        .select('id, requester_id, receiver_id, status')
        .or(
          'and(requester_id.eq.$currentUserId,receiver_id.eq.$otherUserId),'
          'and(requester_id.eq.$otherUserId,receiver_id.eq.$currentUserId)',
        )
        .maybeSingle();

    return data;
  }

  static Future<String?> getConnectionStatus({
    required String currentUserId,
    required String otherUserId,
  }) async {
    final connection = await getConnection(
      currentUserId: currentUserId,
      otherUserId: otherUserId,
    );

    return connection?['status'] as String?;
  }

  static Future<void> sendRequest({
    required String requesterId,
    required String receiverId,
  }) async {
    if (requesterId == receiverId) {
      throw Exception('You cannot connect with yourself.');
    }

    final existingConnection = await getConnection(
      currentUserId: requesterId,
      otherUserId: receiverId,
    );

    if (existingConnection != null) {
      throw Exception(
        'A connection request already exists with this person.',
      );
    }

    await SupabaseService.client.from('connections').insert({
      'requester_id': requesterId,
      'receiver_id': receiverId,
      'status': 'pending',
    });
  }

  static Future<List<Map<String, dynamic>>> getPendingRequests(
    String userId,
  ) async {
    final data = await SupabaseService.client
        .from('connections')
        .select('id, requester_id, receiver_id, status, created_at')
        .eq('receiver_id', userId)
        .eq('status', 'pending')
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(data);
  }

  static Future<void> acceptRequest({
    required String connectionId,
  }) async {
    await SupabaseService.client
        .from('connections')
        .update({
          'status': 'accepted',
          'updated_at': DateTime.now().toUtc().toIso8601String(),
        })
        .eq('id', connectionId);
  }

  static Future<void> rejectRequest({
    required String connectionId,
  }) async {
    await SupabaseService.client
        .from('connections')
        .update({
          'status': 'rejected',
          'updated_at': DateTime.now().toUtc().toIso8601String(),
        })
        .eq('id', connectionId);
  }

  static Future<List<Map<String, dynamic>>> getAcceptedConnections(
    String userId,
  ) async {
    final data = await SupabaseService.client
        .from('connections')
        .select('id, requester_id, receiver_id, status, created_at')
        .eq('status', 'accepted')
        .or(
          'requester_id.eq.$userId,receiver_id.eq.$userId',
        )
        .order('updated_at', ascending: false);

    return List<Map<String, dynamic>>.from(data);
  }
}
