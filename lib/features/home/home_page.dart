import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../shared/widgets/footer.dart';
import '../../shared/widgets/responsive_container.dart';
import '../../shared/widgets/section_title.dart';
import '../../shared/widgets/product_card.dart';
import '../../shared/widgets/primary_button.dart';
import '../../features/cart/providers/cart_provider.dart';
import '../../features/cart/models/cart_item_model.dart';
import '../../features/products/providers/product_provider.dart';
import 'widgets/hero_slider.dart';
import 'widgets/testimonials_section.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final featuredAsync = ref.watch(featuredProductsProvider);

    return SingleChildScrollView(
      child: Column(
        children: [
          // Hero
          const HeroSlider(),

          // Featured Products
          const SizedBox(height: 72),
          ResponsiveContainer(
            child: Column(
              children: [
                const SectionTitle(
                  title: 'Our Bestsellers',
                  subtitle:
                      'Baked fresh every morning with the finest ingredients.',
                ),
                const SizedBox(height: 40),
                featuredAsync.when(
                  loading: () => const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                    ),
                  ),
                  error: (e, _) => Center(
                    child: Text(
                      'Could not load products.',
                      style: AppTypography.bodyLarge,
                    ),
                  ),
                  data: (products) => products.isEmpty
                      ? Center(
                          child: Text(
                            'No featured products yet.',
                            style: AppTypography.bodyLarge,
                          ),
                        )
                      : GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 300,
                            mainAxisSpacing: 24,
                            crossAxisSpacing: 24,
                            childAspectRatio: 0.55,
                          ),
                          itemCount: products.length,
                          itemBuilder: (_, i) => ProductCard(
                            product: products[i],
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
                                  content: Text(
                                    '${products[i].name} added to cart!',
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                ),
                const SizedBox(height: 36),
                PrimaryButton(
                  label: 'View All Products',
                  onPressed: () => context.go('/shop'),
                ),
              ],
            ),
          ),

          // About Preview
          const SizedBox(height: 80),
          Container(
            color: AppColors.secondary,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 64, horizontal: 24),
            child: ResponsiveContainer(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isMobile = constraints.maxWidth < 800;
                  if (isMobile) {
                    return Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SectionTitle(
                              title: 'Crafted with Heart',
                              subtitle:
                                  'Every bite tells a story of flour, butter, and old-world passion. We bake from scratch — no shortcuts, no preservatives.',
                              alignment: CrossAxisAlignment.start,
                              showDivider: false,
                            ),
                            const SizedBox(height: 24),
                            PrimaryButton(
                              label: 'Our Story',
                              onPressed: () => context.go('/contact'),
                              isOutlined: true,
                            ),
                          ],
                        ),
                        const SizedBox(height: 48),
                        _AboutStat(),
                      ],
                    );
                  }
                  return Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SectionTitle(
                              title: 'Crafted with Heart',
                              subtitle:
                                  'Every bite tells a story of flour, butter, and old-world passion. We bake from scratch — no shortcuts, no preservatives.',
                              alignment: CrossAxisAlignment.start,
                              showDivider: false,
                            ),
                            const SizedBox(height: 24),
                            PrimaryButton(
                              label: 'Our Story',
                              onPressed: () => context.go('/contact'),
                              isOutlined: true,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 48),
                      Expanded(child: _AboutStat()),
                    ],
                  );
                },
              ),
            ),
          ),

          // Testimonials
          const SizedBox(height: 72),
          const TestimonialsSection(),

          // CTA Banner
          const SizedBox(height: 72),
          _CtaBanner(),

          const SizedBox(height: 72),
          const Footer(),
        ],
      ),
    );
  }
}

class _AboutStat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 32,
      runSpacing: 24,
      children: const [
        _StatItem(value: '15+', label: 'Years of Baking'),
        _StatItem(value: '200+', label: 'Recipes'),
        _StatItem(value: '10K+', label: 'Happy Customers'),
        _StatItem(value: '50+', label: 'Flavours'),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: AppTypography.displaySmall.copyWith(color: AppColors.accent),
        ),
        const SizedBox(height: 4),
        Text(label, style: AppTypography.labelMedium),
      ],
    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1);
  }
}

class _CtaBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(gradient: AppColors.heroGradient),
      padding: const EdgeInsets.symmetric(vertical: 64, horizontal: 24),
      child: Column(
        children: [
          Text(
            'Fresh Pastries Delivered\nto Your Door',
            style: AppTypography.displayMedium.copyWith(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Text(
            'Order now and taste the difference hand-baked makes.',
            style: AppTypography.bodyLarge.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 32),
          PrimaryButton(
            label: 'Order Now',
            onPressed: () => context.go('/shop'),
          ),
        ],
      ),
    );
  }
}
