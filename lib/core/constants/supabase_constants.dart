import 'package:flutter_dotenv/flutter_dotenv.dart';

/// All Supabase configuration is loaded from the .env file at runtime.
/// Never hard-code credentials here!
class SupabaseConstants {
  SupabaseConstants._();

  static String get supabaseUrl {
    final url = dotenv.env['SUPABASE_URL'] ??
        const String.fromEnvironment('SUPABASE_URL');
    if (url.isEmpty)
      throw Exception('SUPABASE_URL not set in .env or --dart-define');
    return url;
  }

  static String get supabaseAnonKey {
    final key = dotenv.env['SUPABASE_ANON_KEY'] ??
        const String.fromEnvironment('SUPABASE_ANON_KEY');
    if (key.isEmpty)
      throw Exception('SUPABASE_ANON_KEY not set in .env or --dart-define');
    return key;
  }

  // Storage bucket names
  static const String productImagesBucket = 'product-images';
  static const String blogImagesBucket = 'blog-images';

  // Table names
  static const String categoriesTable = 'categories';
  static const String productsTable = 'products';
  static const String ordersTable = 'orders';
  static const String orderItemsTable = 'order_items';
  static const String blogPostsTable = 'blog_posts';
  static const String inquiriesTable = 'inquiries';
}
