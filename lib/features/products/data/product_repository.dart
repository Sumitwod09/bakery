import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../shared/services/supabase_service.dart';
import '../../../core/constants/supabase_constants.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';

class ProductRepository {
  final SupabaseClient _client = SupabaseService.instance.client;

  Future<List<CategoryModel>> fetchCategories() async {
    final response = await _client
        .from(SupabaseConstants.categoriesTable)
        .select()
        .order('name');
    return (response as List)
        .map((json) => CategoryModel.fromJson(json))
        .toList();
  }

  Future<List<ProductModel>> fetchProducts({String? categoryId}) async {
    var query = _client
        .from(SupabaseConstants.productsTable)
        .select()
        .eq('is_available', true);
    if (categoryId != null) {
      query = query.eq('category_id', categoryId);
    }
    final response = await query.order('created_at', ascending: false);
    return (response as List)
        .map((json) => ProductModel.fromJson(json))
        .toList();
  }

  Future<List<ProductModel>> fetchFeaturedProducts() async {
    final response = await _client
        .from(SupabaseConstants.productsTable)
        .select()
        .eq('is_featured', true)
        .eq('is_available', true)
        .order('created_at', ascending: false)
        .limit(8);
    return (response as List)
        .map((json) => ProductModel.fromJson(json))
        .toList();
  }

  Future<ProductModel?> fetchProductBySlug(String slug) async {
    final response = await _client
        .from(SupabaseConstants.productsTable)
        .select()
        .eq('slug', slug)
        .maybeSingle();
    if (response == null) return null;
    return ProductModel.fromJson(response);
  }

  Future<void> createProduct(Map<String, dynamic> productData) async {
    await _client.from(SupabaseConstants.productsTable).insert(productData);
  }

  Future<void> updateProduct(
      String id, Map<String, dynamic> productData) async {
    await _client
        .from(SupabaseConstants.productsTable)
        .update(productData)
        .eq('id', id);
  }

  Future<void> deleteProduct(String id) async {
    await _client.from(SupabaseConstants.productsTable).delete().eq('id', id);
  }

  Future<String> uploadProductImage(String filePath, Uint8List bytes) async {
    final path = 'products/$filePath';
    await _client.storage
        .from(SupabaseConstants.productImagesBucket)
        .uploadBinary(path, bytes,
            fileOptions: const FileOptions(upsert: true));
    return _client.storage
        .from(SupabaseConstants.productImagesBucket)
        .getPublicUrl(path);
  }
}
