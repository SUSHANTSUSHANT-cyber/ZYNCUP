import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../services/supabase_service.dart';

class ZyncupProfile {
  const ZyncupProfile({
    required this.id,
    required this.zyncupId,
    required this.displayName,
    required this.onboardingCompleted,
    this.bio,
    this.profileImageUrl,
    this.phone,
    this.email,
    this.website,
    this.instagram,
    this.linkedin,
    this.otherSocial,
    required this.sharePhone,
    required this.shareEmail,
    required this.shareWebsite,
    required this.shareInstagram,
    required this.shareLinkedin,
    required this.shareOtherSocial,
  });

  final String id;
  final String zyncupId;
  final String displayName;
  final String? bio;
  final String? profileImageUrl;

  final String? phone;
  final String? email;
  final String? website;

  final String? instagram;
  final String? linkedin;
  final String? otherSocial;

  final bool sharePhone;
  final bool shareEmail;
  final bool shareWebsite;
  final bool shareInstagram;
  final bool shareLinkedin;
  final bool shareOtherSocial;

  final bool onboardingCompleted;

  factory ZyncupProfile.fromMap(Map<String, dynamic> map) {
    return ZyncupProfile(
      id: map['id'] as String,
      zyncupId: map['zyncup_id'] as String,
      displayName: (map['display_name'] as String? ?? '').trim(),
      bio: map['bio'] as String?,
      profileImageUrl: map['profile_image_url'] as String?,
      phone: map['phone'] as String?,
      email: map['email'] as String?,
      website: map['website'] as String?,
      instagram: map['instagram'] as String?,
      linkedin: map['linkedin'] as String?,
      otherSocial: map['other_social'] as String?,
      sharePhone: map['share_phone'] as bool? ?? false,
      shareEmail: map['share_email'] as bool? ?? false,
      shareWebsite: map['share_website'] as bool? ?? false,
      shareInstagram: map['share_instagram'] as bool? ?? false,
      shareLinkedin: map['share_linkedin'] as bool? ?? false,
      shareOtherSocial: map['share_other_social'] as bool? ?? false,
      onboardingCompleted:
          map['onboarding_completed'] as bool? ?? false,
    );
  }
}

class ProfileService {
  ProfileService._();

  static Future<ZyncupProfile?> getProfile(String userId) async {
    final data = await SupabaseService.client
        .from('profiles')
        .select(
          '''
          id,
          zyncup_id,
          display_name,
          bio,
          profile_image_url,
          phone,
          email,
          website,
          instagram,
          linkedin,
          other_social,
          share_phone,
          share_email,
          share_website,
          share_instagram,
          share_linkedin,
          share_other_social,
          onboarding_completed
          ''',
        )
        .eq('id', userId)
        .maybeSingle();

    if (data == null) {
      return null;
    }

    return ZyncupProfile.fromMap(data);
  }

  static Future<ZyncupProfile?> getProfileByZyncupId(
    String zyncupId,
  ) async {
    final data = await SupabaseService.client
        .from('profiles')
        .select(
          '''
          id,
          zyncup_id,
          display_name,
          bio,
          profile_image_url,
          phone,
          email,
          website,
          instagram,
          linkedin,
          other_social,
          share_phone,
          share_email,
          share_website,
          share_instagram,
          share_linkedin,
          share_other_social,
          onboarding_completed
          ''',
        )
        .eq('zyncup_id', zyncupId.trim())
        .maybeSingle();

    if (data == null) {
      return null;
    }

    return ZyncupProfile.fromMap(data);
  }

  static Future<void> completeProfile({
    required String userId,
    required String displayName,
    String? profileImageUrl,
    String? bio,
    String? phone,
    String? email,
    String? website,
    String? instagram,
    String? linkedin,
    String? otherSocial,
    bool sharePhone = false,
    bool shareEmail = false,
    bool shareWebsite = false,
    bool shareInstagram = false,
    bool shareLinkedin = false,
    bool shareOtherSocial = false,
  }) async {
    final result = await SupabaseService.client
        .from('profiles')
        .update({
          'display_name': displayName.trim(),
          'profile_image_url': _nullableValue(profileImageUrl),
          'bio': _nullableValue(bio),
          'phone': _nullableValue(phone),
          'email': _nullableValue(email),
          'website': _nullableValue(website),
          'instagram': _nullableValue(instagram),
          'linkedin': _nullableValue(linkedin),
          'other_social': _nullableValue(otherSocial),
          'share_phone': sharePhone,
          'share_email': shareEmail,
          'share_website': shareWebsite,
          'share_instagram': shareInstagram,
          'share_linkedin': shareLinkedin,
          'share_other_social': shareOtherSocial,
          'onboarding_completed': true,
        })
        .eq('id', userId)
        .select()
        .single();

    debugPrint('========== PROFILE UPDATE RESULT ==========');
    debugPrint(result.toString());
    debugPrint('===========================================');
  }

  static Future<String> uploadProfileImage({
    required String userId,
    required Uint8List imageBytes,
    required String fileExtension,
    required String contentType,
  }) async {
    final filePath = '$userId/profile.$fileExtension';
    final storage = SupabaseService.client.storage.from('profile-images');
    final session = SupabaseService.client.auth.currentSession;
    final currentUser = SupabaseService.client.auth.currentUser;

    debugPrint('========== PROFILE IMAGE UPLOAD DEBUG ==========');
    debugPrint('Bucket: profile-images');
    debugPrint('File path: $filePath');
    debugPrint('User ID argument: $userId');
    debugPrint('Auth user ID: ');
    debugPrint('Auth session present: ${session != null}');
    debugPrint('Access token present: ${session?.accessToken.isNotEmpty}');
    debugPrint('File extension: $fileExtension');
    debugPrint('Content type: $contentType');
    debugPrint('File size: ${imageBytes.length} bytes');
    debugPrint('================================================');

    if (currentUser == null) {
      throw const AuthException(
        'No authenticated user is available for profile image upload.',
      );
    }

    if (currentUser.id != userId) {
      throw AuthException(
        'Profile image upload user mismatch. Expected , received .',
      );
    }

    try { 
      await storage.uploadBinary(
        filePath,
        imageBytes,
        fileOptions: FileOptions(
          upsert: true,
          contentType: contentType,
        ),
      );

      debugPrint('========== PROFILE IMAGE UPLOAD SUCCESS ==========');
      debugPrint('Uploaded path: $filePath');
      debugPrint('=================================================');

      final publicUrl = storage.getPublicUrl(filePath);

      return '$publicUrl?v=${DateTime.now().millisecondsSinceEpoch}';
    } catch (error) {
      debugPrint('========== PROFILE IMAGE UPLOAD FAILED ==========');
      debugPrint('Bucket: profile-images');
      debugPrint('File path: $filePath');
      debugPrint('Auth user ID: ');
      debugPrint('Auth session present: ${session != null}');
      debugPrint('Error: $error');
      debugPrint('=================================================');

      rethrow;
    }
  }

  static Future<void> updateProfile({
    required String userId,
    required String displayName,
    String? profileImageUrl,
    String? bio,
    String? phone,
    String? email,
    String? website,
    String? instagram,
    String? linkedin,
    String? otherSocial,
    bool sharePhone = false,
    bool shareEmail = false,
    bool shareWebsite = false,
    bool shareInstagram = false,
    bool shareLinkedin = false,
    bool shareOtherSocial = false,
  }) async {
    await SupabaseService.client
        .from('profiles')
        .update({
          'display_name': displayName.trim(),
          'profile_image_url': _nullableValue(profileImageUrl),
          'bio': _nullableValue(bio),
          'phone': _nullableValue(phone),
          'email': _nullableValue(email),
          'website': _nullableValue(website),
          'instagram': _nullableValue(instagram),
          'linkedin': _nullableValue(linkedin),
          'other_social': _nullableValue(otherSocial),
          'share_phone': sharePhone,
          'share_email': shareEmail,
          'share_website': shareWebsite,
          'share_instagram': shareInstagram,
          'share_linkedin': shareLinkedin,
          'share_other_social': shareOtherSocial,
        })
        .eq('id', userId);
  }

  static String? _nullableValue(String? value) {
    if (value == null) {
      return null;
    }

    final trimmedValue = value.trim();

    if (trimmedValue.isEmpty) {
      return null;
    }

    return trimmedValue;
  }
}

