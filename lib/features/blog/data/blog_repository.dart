import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../shared/services/supabase_service.dart';
import '../../../core/constants/supabase_constants.dart';
import '../models/blog_post_model.dart';

class BlogRepository {
  final SupabaseClient _client = SupabaseService.instance.client;

  Future<List<BlogPostModel>> fetchPublishedPosts() async {
    final response = await _client
        .from(SupabaseConstants.blogPostsTable)
        .select()
        .eq('published', true)
        .order('created_at', ascending: false);
    return (response as List)
        .map((json) => BlogPostModel.fromJson(json))
        .toList();
  }

  Future<BlogPostModel?> fetchPostBySlug(String slug) async {
    final response = await _client
        .from(SupabaseConstants.blogPostsTable)
        .select()
        .eq('slug', slug)
        .eq('published', true)
        .maybeSingle();
    if (response == null) return null;
    return BlogPostModel.fromJson(response);
  }

  Future<List<BlogPostModel>> fetchAllPosts() async {
    final response = await _client
        .from(SupabaseConstants.blogPostsTable)
        .select()
        .order('created_at', ascending: false);
    return (response as List)
        .map((json) => BlogPostModel.fromJson(json))
        .toList();
  }

  Future<void> createPost(Map<String, dynamic> postData) async {
    await _client.from(SupabaseConstants.blogPostsTable).insert(postData);
  }

  Future<void> updatePost(String id, Map<String, dynamic> postData) async {
    await _client
        .from(SupabaseConstants.blogPostsTable)
        .update(postData)
        .eq('id', id);
  }

  Future<void> deletePost(String id) async {
    await _client.from(SupabaseConstants.blogPostsTable).delete().eq('id', id);
  }
}
