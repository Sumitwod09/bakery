import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../shared/services/supabase_service.dart';
import '../../../core/constants/supabase_constants.dart';
import '../models/order_model.dart';

class OrderRepository {
  final SupabaseClient _client = SupabaseService.instance.client;

  Future<String> createOrder({
    required OrderModel order,
    required List<OrderItemModel> items,
  }) async {
    final computedTotal =
        items.fold<double>(0, (sum, item) => sum + item.subtotal);

    final orderData = order.toJson()..['total_amount'] = computedTotal;

    final orderResponse = await _client
        .from(SupabaseConstants.ordersTable)
        .insert(orderData)
        .select('id')
        .single();

    final orderId = orderResponse['id'] as String;

    final itemsData =
        items.map((item) => item.toJson()..['order_id'] = orderId).toList();

    await _client.from(SupabaseConstants.orderItemsTable).insert(itemsData);

    return orderId;
  }

  Future<List<Map<String, dynamic>>> fetchAllOrders() async {
    final response = await _client
        .from(SupabaseConstants.ordersTable)
        .select()
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response as List);
  }

  Future<List<Map<String, dynamic>>> fetchOrderItems(String orderId) async {
    final response = await _client
        .from(SupabaseConstants.orderItemsTable)
        .select()
        .eq('order_id', orderId);
    return List<Map<String, dynamic>>.from(response as List);
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    await _client
        .from(SupabaseConstants.ordersTable)
        .update({'status': status}).eq('id', orderId);
  }
}
