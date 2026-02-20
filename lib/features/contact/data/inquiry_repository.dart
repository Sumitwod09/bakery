import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../shared/services/supabase_service.dart';
import '../../../core/constants/supabase_constants.dart';

class InquiryRepository {
  final SupabaseClient _client = SupabaseService.instance.client;

  Future<void> submitInquiry({
    required String name,
    required String email,
    required String message,
  }) async {
    await _client.from(SupabaseConstants.inquiriesTable).insert({
      'name': name,
      'email': email,
      'message': message,
    });
  }
}
