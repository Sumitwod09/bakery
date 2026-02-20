import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../shared/widgets/footer.dart';
import '../../shared/widgets/responsive_container.dart';
import '../../shared/widgets/section_title.dart';
import '../../shared/widgets/product_card.dart';
import '../../features/products/providers/product_provider.dart';
import '../../features/cart/providers/cart_provider.dart';
import '../../features/cart/models/cart_item_model.dart';
import '../../features/products/models/category_model.dart';

class ShopPage extends ConsumerWidget {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final categoriesAsync = ref.watch(categoriesProvider);
    final productsAsync = ref.watch(productsProvider(selectedCategory));
    final cartItems = ref.watch(cartProvider);

    return SingleChildScrollView(
      child: Column(
        children: [
          // Page header
          Container(
            color: AppColors.secondary,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
            child: const SectionTitle(
              title: 'Anmol Bakery Shop',
              subtitle: 'Explore handcrafted goods, made fresh every day.',
            ),
          ),
          const SizedBox(height: 40),
          ResponsiveContainer(
            child: Column(
              children: [
                // Category filters
                categoriesAsync.when(
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                  data: (categories) => _CategoryFilter(
                    categories: categories,
                    selected: selectedCategory,
                    onSelect: (id) =>
                        ref.read(selectedCategoryProvider.notifier).state = id,
                  ),
                ),
                const SizedBox(height: 32),
                // Products grid
                productsAsync.when(
                  loading: () => const Center(
                    child: Padding(
                      padding: EdgeInsets.all(64),
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  error: (e, _) => Center(
                    child: Padding(
                      padding: const EdgeInsets.all(64),
                      child: Text(
                        'Error loading products: $e',
                        style: AppTypography.bodyLarge,
                      ),
                    ),
                  ),
                  data: (products) => products.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(64),
                            child: Text(
                              'No products found.',
                              style: AppTypography.bodyLarge,
                            ),
                          ),
                        )
                      : GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 300,
                            mainAxisSpacing: 24,
                            crossAxisSpacing: 24,
                            childAspectRatio: 0.55,
                          ),
                          itemCount: products.length,
                          itemBuilder: (_, i) {
                            final qty = cartItems
                                .where((e) => e.productId == products[i].id)
                                .fold(0, (sum, e) => sum + e.quantity);
                            return ProductCard(
                              product: products[i],
                              quantity: qty,
                              onAddToCart: () {
                                ref.read(cartProvider.notifier).addItem(
                                      CartItemModel(
                                        productId: products[i].id,
                                        productName: products[i].name,
                                        productPrice: products[i].price,
                                        productImage: products[i].primaryImage,
                                        quantity: 1,
                                      ),
                                    );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('${products[i].name} added!'),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                ),
                const SizedBox(height: 64),
              ],
            ),
          ),
          const Footer(),
        ],
      ),
    );
  }
}

class _CategoryFilter extends StatelessWidget {
  final List<CategoryModel> categories;
  final String? selected;
  final ValueChanged<String?> onSelect;

  const _CategoryFilter({
    required this.categories,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 10,
      children: [
        _FilterChip(
          label: 'All',
          isSelected: selected == null,
          onTap: () => onSelect(null),
        ),
        ...categories.map(
          (c) => _FilterChip(
            label: c.name,
            isSelected: selected == c.id,
            onTap: () => onSelect(c.id),
          ),
        ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.divider,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: AppTypography.labelMedium.copyWith(
            color: isSelected ? Colors.white : AppColors.textMedium,
          ),
        ),
      ),
    );
  }
}
