import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/utils/formatters.dart';
import '../../shared/widgets/footer.dart';
import '../../shared/widgets/primary_button.dart';
import '../../shared/widgets/responsive_container.dart';
import '../../shared/widgets/section_title.dart';
import '../cart/providers/cart_provider.dart';

class CartPage extends ConsumerWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);

    return cart.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.shopping_bag_outlined,
                  size: 80,
                  color: AppColors.divider,
                ),
                const SizedBox(height: 20),
                Text(
                  'Your cart is empty',
                  style: AppTypography.headlineMedium,
                ),
                const SizedBox(height: 12),
                Text(
                  'Add some delicious items!',
                  style: AppTypography.bodyLarge,
                ),
                const SizedBox(height: 32),
                PrimaryButton(
                  label: 'Go to Shop',
                  onPressed: () => context.go('/shop'),
                ),
              ],
            ),
          )
        : SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  color: AppColors.secondary,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 32,
                    horizontal: 24,
                  ),
                  child: const SectionTitle(
                    title: 'Your Cart',
                    subtitle: null,
                    showDivider: false,
                  ),
                ),
                const SizedBox(height: 32),
                ResponsiveContainer(
                  child: Column(
                    children: [
                      // Cart items
                      ...cart.map(
                        (item) => _CartRow(
                          item: item,
                          onIncrease: () => cartNotifier.updateQuantity(
                            item.productId,
                            item.quantity + 1,
                          ),
                          onDecrease: () => cartNotifier.updateQuantity(
                            item.productId,
                            item.quantity - 1,
                          ),
                          onRemove: () =>
                              cartNotifier.removeItem(item.productId),
                        ),
                      ),
                      const Divider(height: 40),
                      // Summary
                      _CartSummary(
                        total: cartNotifier.total,
                        onCheckout: () => context.push('/checkout'),
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

class _CartRow extends StatelessWidget {
  final dynamic item;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final VoidCallback onRemove;

  const _CartRow({
    required this.item,
    required this.onIncrease,
    required this.onDecrease,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 500;

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: EdgeInsets.all(isMobile ? 12 : 16),
          decoration: BoxDecoration(
            color: AppColors.surfaceColor(context),
            borderRadius: BorderRadius.circular(12),
            border:
                Border.all(color: AppColors.dividerColor(context), width: 0.5),
          ),
          child: isMobile
              ? _buildMobileLayout(context)
              : _buildDesktopLayout(context),
        ).animate().fadeIn(duration: 200.ms);
      },
    );
  }

  /// Mobile: two-row stacked layout
  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      children: [
        // Row 1: Image + Name + Remove
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 64,
                height: 64,
                child: item.productImage.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: item.productImage,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        color: AppColors.secondary,
                        child: const Icon(
                          Icons.bakery_dining,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.productName,
                    style: AppTypography.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary(context),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    Formatters.formatPrice(item.productPrice),
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textLight,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 32,
              height: 32,
              child: IconButton(
                padding: EdgeInsets.zero,
                iconSize: 18,
                icon: const Icon(Icons.close, color: AppColors.textLight),
                onPressed: onRemove,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Row 2: Quantity controls + Subtotal
        Row(
          children: [
            // Quantity controls
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.dividerColor(context)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 32,
                    height: 32,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      iconSize: 16,
                      icon: const Icon(Icons.remove),
                      color: AppColors.primary,
                      onPressed: onDecrease,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      '${item.quantity}',
                      style: AppTypography.labelLarge,
                    ),
                  ),
                  SizedBox(
                    width: 32,
                    height: 32,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      iconSize: 16,
                      icon: const Icon(Icons.add),
                      color: AppColors.primary,
                      onPressed: onIncrease,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Text(
              Formatters.formatPrice(item.subtotal),
              style: AppTypography.priceText.copyWith(fontSize: 16),
            ),
          ],
        ),
      ],
    );
  }

  /// Desktop: horizontal layout
  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            width: 80,
            height: 80,
            child: item.productImage.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: item.productImage,
                    fit: BoxFit.cover,
                  )
                : Container(
                    color: AppColors.secondary,
                    child: const Icon(
                      Icons.bakery_dining,
                      color: AppColors.primary,
                    ),
                  ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.productName,
                style: AppTypography.headlineSmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                Formatters.formatPrice(item.productPrice),
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textLight,
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.remove_circle_outline),
              color: AppColors.primary,
              onPressed: onDecrease,
            ),
            Text('${item.quantity}', style: AppTypography.headlineSmall),
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              color: AppColors.primary,
              onPressed: onIncrease,
            ),
          ],
        ),
        const SizedBox(width: 8),
        Text(
          Formatters.formatPrice(item.subtotal),
          style: AppTypography.priceText,
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.close, color: AppColors.textLight),
          onPressed: onRemove,
        ),
      ],
    );
  }
}

class _CartSummary extends StatelessWidget {
  final double total;
  final VoidCallback onCheckout;
  const _CartSummary({required this.total, required this.onCheckout});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Subtotal', style: AppTypography.bodyLarge),
              Text(
                Formatters.formatPrice(total),
                style: AppTypography.headlineSmall,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Delivery', style: AppTypography.bodyLarge),
              Text(
                'Free',
                style: AppTypography.bodyLarge.copyWith(
                  color: AppColors.success,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total', style: AppTypography.headlineMedium),
              Text(
                Formatters.formatPrice(total),
                style: AppTypography.priceText.copyWith(fontSize: 24),
              ),
            ],
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            label: 'Proceed to Checkout',
            icon: Icons.arrow_forward,
            onPressed: onCheckout,
            width: double.infinity,
          ),
        ],
      ),
    );
  }
}
