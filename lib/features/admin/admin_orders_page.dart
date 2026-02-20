import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/utils/formatters.dart';
import '../../features/checkout/providers/order_provider.dart';
import '../../features/checkout/data/order_repository.dart';
import 'widgets/admin_sidebar.dart';

class AdminOrdersPage extends ConsumerWidget {
  const AdminOrdersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(allOrdersProvider);

    return Scaffold(
      backgroundColor: AppColors.bg(context),
      body: Row(
        children: [
          const AdminSidebar(currentRoute: '/admin/orders'),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Orders', style: AppTypography.displaySmall),
                  const SizedBox(height: 32),
                  ordersAsync.when(
                    loading: () => const Center(
                        child: CircularProgressIndicator(
                            color: AppColors.primary)),
                    error: (e, _) => Text('Error: $e'),
                    data: (orders) => orders.isEmpty
                        ? Text('No orders yet.', style: AppTypography.bodyLarge)
                        : Column(
                            children: orders
                                .map((o) => _OrderTile(
                                      order: o,
                                      onStatusChange: (status) async {
                                        await OrderRepository()
                                            .updateOrderStatus(
                                                o['id'] as String, status);
                                        ref.invalidate(allOrdersProvider);
                                      },
                                    ))
                                .toList(),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderTile extends StatelessWidget {
  final Map<String, dynamic> order;
  final ValueChanged<String> onStatusChange;

  const _OrderTile({required this.order, required this.onStatusChange});

  Color _statusColor(String status) => switch (status) {
        'confirmed' => AppColors.success,
        'delivered' => const Color(0xFF00A67E),
        'cancelled' => AppColors.error,
        _ => AppColors.warning,
      };

  @override
  Widget build(BuildContext context) {
    final status = order['status'] as String? ?? 'pending';
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor(context),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Order #${(order['id'] as String).substring(0, 8)}',
                    style: AppTypography.labelLarge),
                const SizedBox(height: 4),
                Text(order['customer_name'] as String? ?? '',
                    style: AppTypography.bodyMedium),
                Text(order['customer_phone'] as String? ?? '',
                    style: AppTypography.bodySmall),
                const SizedBox(height: 4),
                Text(
                  order['created_at'] != null
                      ? Formatters.formatDateTime(
                          DateTime.parse(order['created_at'] as String))
                      : '',
                  style: AppTypography.caption,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                Formatters.formatPrice(
                    (order['total_amount'] as num).toDouble()),
                style: AppTypography.priceText.copyWith(fontSize: 18),
              ),
              const SizedBox(height: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _statusColor(status).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  status.toUpperCase(),
                  style: AppTypography.caption.copyWith(
                      color: _statusColor(status), fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          PopupMenuButton<String>(
            onSelected: onStatusChange,
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'pending', child: Text('Pending')),
              PopupMenuItem(value: 'confirmed', child: Text('Confirmed')),
              PopupMenuItem(value: 'delivered', child: Text('Delivered')),
              PopupMenuItem(value: 'cancelled', child: Text('Cancelled')),
            ],
            icon: const Icon(Icons.more_vert, color: AppColors.textLight),
          ),
        ],
      ),
    );
  }
}
