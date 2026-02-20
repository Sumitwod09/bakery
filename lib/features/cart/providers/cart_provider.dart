import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cart_item_model.dart';

class CartNotifier extends Notifier<List<CartItemModel>> {
  @override
  List<CartItemModel> build() => [];

  void addItem(CartItemModel item) {
    final existing = state.indexWhere((e) => e.productId == item.productId);
    if (existing >= 0) {
      // Increase quantity
      final updated = List<CartItemModel>.from(state);
      updated[existing] = updated[existing].copyWith(
        quantity: updated[existing].quantity + item.quantity,
      );
      state = updated;
    } else {
      state = [...state, item];
    }
  }

  void removeItem(String productId) {
    state = state.where((e) => e.productId != productId).toList();
  }

  void updateQuantity(String productId, int quantity) {
    if (quantity <= 0) {
      removeItem(productId);
      return;
    }
    state = state
        .map(
          (e) => e.productId == productId ? e.copyWith(quantity: quantity) : e,
        )
        .toList();
  }

  void clear() => state = [];

  double get total => state.fold(0, (sum, item) => sum + item.subtotal);

  int get itemCount => state.fold(0, (sum, item) => sum + item.quantity);

  bool contains(String productId) => state.any((e) => e.productId == productId);
}

final cartProvider = NotifierProvider<CartNotifier, List<CartItemModel>>(
  CartNotifier.new,
);

// Convenience computed providers
final cartTotalProvider = Provider<double>((ref) {
  final cart = ref.watch(cartProvider.notifier);
  return cart.total;
});

final cartItemCountProvider = Provider<int>((ref) {
  final cart = ref.watch(cartProvider.notifier);
  return cart.itemCount;
});
