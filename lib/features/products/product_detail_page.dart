import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/utils/formatters.dart';
import '../../shared/widgets/custom_app_bar.dart';
import '../../shared/widgets/footer.dart';
import '../../shared/widgets/primary_button.dart';
import '../../shared/widgets/responsive_container.dart';
import '../../features/products/providers/product_provider.dart';
import '../../features/cart/providers/cart_provider.dart';
import '../../features/cart/models/cart_item_model.dart';

class ProductDetailPage extends ConsumerStatefulWidget {
  final String slug;
  const ProductDetailPage({super.key, required this.slug});

  @override
  ConsumerState<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends ConsumerState<ProductDetailPage> {
  int _quantity = 1;
  int _imageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final productAsync = ref.watch(productBySlugProvider(widget.slug));
    final isMobile = MediaQuery.of(context).size.width < 800;

    return Scaffold(
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            productAsync.when(
              loading: () => const Padding(
                padding: EdgeInsets.all(80),
                child: Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              ),
              error: (e, _) => Padding(
                padding: const EdgeInsets.all(80),
                child: Text(
                  'Product not found.',
                  style: AppTypography.bodyLarge,
                ),
              ),
              data: (product) {
                if (product == null) {
                  return Padding(
                    padding: const EdgeInsets.all(80),
                    child: Text(
                      'Product not found.',
                      style: AppTypography.bodyLarge,
                    ),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 48),
                  child: ResponsiveContainer(
                    child: isMobile
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _ImageCarousel(
                                images: product.imageUrls,
                                currentIndex: _imageIndex,
                                onChanged: (i) =>
                                    setState(() => _imageIndex = i),
                              ),
                              const SizedBox(height: 32),
                              _ProductInfo(
                                product: product,
                                quantity: _quantity,
                                onQuantityChanged: (q) =>
                                    setState(() => _quantity = q),
                                onAddToCart: _addToCart,
                              ),
                            ],
                          )
                        : Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: _ImageCarousel(
                                  images: product.imageUrls,
                                  currentIndex: _imageIndex,
                                  onChanged: (i) =>
                                      setState(() => _imageIndex = i),
                                ),
                              ),
                              const SizedBox(width: 60),
                              Expanded(
                                child: _ProductInfo(
                                  product: product,
                                  quantity: _quantity,
                                  onQuantityChanged: (q) =>
                                      setState(() => _quantity = q),
                                  onAddToCart: _addToCart,
                                ),
                              ),
                            ],
                          ),
                  ),
                );
              },
            ),
            const SizedBox(height: 48),
            const Footer(),
          ],
        ),
      ),
    );
  }

  void _addToCart() {
    final product = ref.read(productBySlugProvider(widget.slug)).value;
    if (product == null) return;
    ref.read(cartProvider.notifier).addItem(
          CartItemModel(
            productId: product.id,
            productName: product.name,
            productPrice: product.price,
            productImage: product.primaryImage,
            quantity: _quantity,
          ),
        );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} added to cart!'),
        action: SnackBarAction(
          label: 'View Cart',
          onPressed: () => context.push('/cart'),
          textColor: AppColors.primaryLight,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Image carousel — uses native PageView (no external dependency)
// ---------------------------------------------------------------------------
class _ImageCarousel extends StatefulWidget {
  final List<String> images;
  final int currentIndex;
  final ValueChanged<int> onChanged;
  const _ImageCarousel({
    required this.images,
    required this.currentIndex,
    required this.onChanged,
  });

  @override
  State<_ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<_ImageCarousel> {
  late final PageController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = PageController();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) {
      return AspectRatio(
        aspectRatio: 1,
        child: Container(
          color: AppColors.secondary,
          child: const Icon(
            Icons.bakery_dining,
            size: 80,
            color: AppColors.primary,
          ),
        ),
      );
    }
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: PageView.builder(
              controller: _ctrl,
              itemCount: widget.images.length,
              onPageChanged: widget.onChanged,
              itemBuilder: (_, i) => Image.network(
                widget.images[i],
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
        ),
        if (widget.images.length > 1) ...[
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.images.length,
              (i) => GestureDetector(
                onTap: () => _ctrl.animateToPage(
                  i,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                ),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: widget.currentIndex == i ? 20 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: widget.currentIndex == i
                        ? AppColors.primary
                        : AppColors.divider,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Product info panel
// ---------------------------------------------------------------------------
class _ProductInfo extends StatelessWidget {
  final dynamic product;
  final int quantity;
  final ValueChanged<int> onQuantityChanged;
  final VoidCallback onAddToCart;
  const _ProductInfo({
    required this.product,
    required this.quantity,
    required this.onQuantityChanged,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(product.name, style: AppTypography.displaySmall),
        const SizedBox(height: 12),
        Text(
          Formatters.formatPrice(product.price),
          style: AppTypography.priceText,
        ),
        const SizedBox(height: 20),
        if (product.description != null)
          Text(product.description!, style: AppTypography.bodyLarge),
        const SizedBox(height: 32),
        // Quantity selector
        Row(
          children: [
            Text('Quantity:', style: AppTypography.labelLarge),
            const SizedBox(width: 16),
            _QuantityButton(
              icon: Icons.remove,
              onTap:
                  quantity > 1 ? () => onQuantityChanged(quantity - 1) : null,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text('$quantity', style: AppTypography.headlineSmall),
            ),
            _QuantityButton(
              icon: Icons.add,
              onTap: () => onQuantityChanged(quantity + 1),
            ),
          ],
        ),
        const SizedBox(height: 32),
        PrimaryButton(
          label: 'Add to Cart',
          icon: Icons.shopping_bag_outlined,
          onPressed: onAddToCart,
          width: double.infinity,
        ),
      ],
    );
  }
}

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  const _QuantityButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          border: Border.all(
            color: onTap == null ? AppColors.divider : AppColors.primary,
          ),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 18,
          color: onTap == null ? AppColors.divider : AppColors.primary,
        ),
      ),
    );
  }
}
