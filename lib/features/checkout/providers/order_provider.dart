import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/order_repository.dart';
import '../models/order_model.dart';

final orderRepositoryProvider = Provider<OrderRepository>(
  (ref) => OrderRepository(),
);

// State for order submission
enum OrderStatus { idle, loading, success, error }

class OrderState {
  final OrderStatus status;
  final String? orderId;
  final String? errorMessage;

  const OrderState({
    this.status = OrderStatus.idle,
    this.orderId,
    this.errorMessage,
  });

  OrderState copyWith({
    OrderStatus? status,
    String? orderId,
    String? errorMessage,
  }) => OrderState(
    status: status ?? this.status,
    orderId: orderId ?? this.orderId,
    errorMessage: errorMessage ?? this.errorMessage,
  );
}

class OrderNotifier extends Notifier<OrderState> {
  @override
  OrderState build() => const OrderState();

  Future<void> placeOrder({
    required OrderModel order,
    required List<OrderItemModel> items,
  }) async {
    state = state.copyWith(status: OrderStatus.loading);
    try {
      final orderId = await ref
          .read(orderRepositoryProvider)
          .createOrder(order: order, items: items);
      state = state.copyWith(status: OrderStatus.success, orderId: orderId);
    } catch (e) {
      state = state.copyWith(
        status: OrderStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  void reset() => state = const OrderState();
}

final orderProvider = NotifierProvider<OrderNotifier, OrderState>(
  OrderNotifier.new,
);

// Admin: all orders
final allOrdersProvider = FutureProvider<List<Map<String, dynamic>>>((
  ref,
) async {
  return ref.read(orderRepositoryProvider).fetchAllOrders();
});
