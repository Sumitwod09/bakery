import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/product_repository.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';

// Singleton repository provider
final productRepositoryProvider = Provider<ProductRepository>(
  (ref) => ProductRepository(),
);

// Selected category filter
final selectedCategoryProvider = StateProvider<String?>((ref) => null);

// All categories
final categoriesProvider = FutureProvider<List<CategoryModel>>((ref) async {
  return ref.read(productRepositoryProvider).fetchCategories();
});

// Products (with optional category filter)
final productsProvider = FutureProvider.family<List<ProductModel>, String?>((
  ref,
  categoryId,
) async {
  return ref
      .read(productRepositoryProvider)
      .fetchProducts(categoryId: categoryId);
});

// Featured products
final featuredProductsProvider = FutureProvider<List<ProductModel>>((
  ref,
) async {
  return ref.read(productRepositoryProvider).fetchFeaturedProducts();
});

// Single product by slug
final productBySlugProvider = FutureProvider.family<ProductModel?, String>((
  ref,
  slug,
) async {
  return ref.read(productRepositoryProvider).fetchProductBySlug(slug);
});
