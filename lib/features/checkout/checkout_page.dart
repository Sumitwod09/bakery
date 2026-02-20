import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/validators.dart';
import '../../shared/widgets/custom_app_bar.dart';
import '../../shared/widgets/footer.dart';
import '../../shared/widgets/primary_button.dart';
import '../../shared/widgets/responsive_container.dart';
import '../../shared/widgets/section_title.dart';
import '../cart/providers/cart_provider.dart';
import '../checkout/models/order_model.dart';
import '../checkout/providers/order_provider.dart';

class CheckoutPage extends ConsumerStatefulWidget {
  const CheckoutPage({super.key});

  @override
  ConsumerState<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends ConsumerState<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _submitOrder() async {
    if (!_formKey.currentState!.validate()) return;

    final cartNotifier = ref.read(cartProvider.notifier);
    final cart = ref.read(cartProvider);

    if (cart.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Your cart is empty!')));
      return;
    }

    final order = OrderModel(
      customerName: _nameCtrl.text.trim(),
      customerPhone: _phoneCtrl.text.trim(),
      customerAddress: _addressCtrl.text.trim(),
      totalAmount: cartNotifier.total,
      notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
    );

    final items = cart
        .map(
          (item) => OrderItemModel(
            productId: item.productId,
            productName: item.productName,
            productPrice: item.productPrice,
            quantity: item.quantity,
          ),
        )
        .toList();

    await ref
        .read(orderProvider.notifier)
        .placeOrder(order: order, items: items);

    final state = ref.read(orderProvider);
    if (state.status == OrderStatus.success && mounted) {
      cartNotifier.clear();
      context.go('/checkout/success?orderId=${state.orderId}');
      ref.read(orderProvider.notifier).reset();
    } else if (state.status == OrderStatus.error && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${state.errorMessage}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);
    final orderState = ref.watch(orderProvider);
    final isMobile = MediaQuery.of(context).size.width < 800;

    return Scaffold(
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: AppColors.secondary,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
              child: const SectionTitle(
                title: 'Checkout',
                subtitle: null,
                showDivider: false,
              ),
            ),
            const SizedBox(height: 32),
            ResponsiveContainer(
              child: isMobile
                  ? Column(
                      children: [
                        _OrderForm(
                          formKey: _formKey,
                          nameCtrl: _nameCtrl,
                          phoneCtrl: _phoneCtrl,
                          addressCtrl: _addressCtrl,
                          notesCtrl: _notesCtrl,
                        ),
                        const SizedBox(height: 32),
                        _OrderSummaryBox(
                          cart: cart,
                          total: cartNotifier.total,
                          isLoading: orderState.status == OrderStatus.loading,
                          onSubmit: _submitOrder,
                        ),
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: _OrderForm(
                            formKey: _formKey,
                            nameCtrl: _nameCtrl,
                            phoneCtrl: _phoneCtrl,
                            addressCtrl: _addressCtrl,
                            notesCtrl: _notesCtrl,
                          ),
                        ),
                        const SizedBox(width: 40),
                        Expanded(
                          flex: 2,
                          child: _OrderSummaryBox(
                            cart: cart,
                            total: cartNotifier.total,
                            isLoading: orderState.status == OrderStatus.loading,
                            onSubmit: _submitOrder,
                          ),
                        ),
                      ],
                    ),
            ),
            const SizedBox(height: 64),
            const Footer(),
          ],
        ),
      ),
    );
  }
}

class _OrderForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameCtrl;
  final TextEditingController phoneCtrl;
  final TextEditingController addressCtrl;
  final TextEditingController notesCtrl;

  const _OrderForm({
    required this.formKey,
    required this.nameCtrl,
    required this.phoneCtrl,
    required this.addressCtrl,
    required this.notesCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Delivery Details', style: AppTypography.headlineMedium),
          const SizedBox(height: 24),
          TextFormField(
            controller: nameCtrl,
            decoration: const InputDecoration(labelText: 'Full Name'),
            validator: (v) => Validators.required(v, fieldName: 'Name'),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: phoneCtrl,
            decoration: const InputDecoration(labelText: 'Phone Number'),
            keyboardType: TextInputType.phone,
            validator: Validators.phone,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: addressCtrl,
            decoration: const InputDecoration(labelText: 'Delivery Address'),
            maxLines: 3,
            validator: (v) => Validators.minLength(v, 10, fieldName: 'Address'),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: notesCtrl,
            decoration: const InputDecoration(
              labelText: 'Special Instructions (optional)',
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.secondary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.local_shipping_outlined,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 12),
                Text(
                  'Cash on Delivery (COD)',
                  style: AppTypography.labelLarge.copyWith(
                    color: AppColors.accent,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderSummaryBox extends StatelessWidget {
  final List cart;
  final double total;
  final bool isLoading;
  final VoidCallback onSubmit;

  const _OrderSummaryBox({
    required this.cart,
    required this.total,
    required this.isLoading,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Order Summary', style: AppTypography.headlineSmall),
          const SizedBox(height: 16),
          ...cart.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '${item.productName} × ${item.quantity}',
                      style: AppTypography.bodyMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    Formatters.formatPrice(item.subtotal),
                    style: AppTypography.labelMedium,
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total', style: AppTypography.headlineMedium),
              Text(
                Formatters.formatPrice(total),
                style: AppTypography.priceText,
              ),
            ],
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            label: 'Place Order',
            icon: Icons.check_circle_outline,
            isLoading: isLoading,
            onPressed: onSubmit,
            width: double.infinity,
          ),
        ],
      ),
    );
  }
}
