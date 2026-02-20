class OrderModel {
  final String? id;
  final String customerName;
  final String customerPhone;
  final String customerAddress;
  final double totalAmount;
  final String status;
  final String? notes;
  final DateTime? createdAt;

  const OrderModel({
    this.id,
    required this.customerName,
    required this.customerPhone,
    required this.customerAddress,
    required this.totalAmount,
    this.status = 'pending',
    this.notes,
    this.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
    id: json['id'] as String?,
    customerName: json['customer_name'] as String,
    customerPhone: json['customer_phone'] as String,
    customerAddress: json['customer_address'] as String,
    totalAmount: (json['total_amount'] as num).toDouble(),
    status: json['status'] as String? ?? 'pending',
    notes: json['notes'] as String?,
    createdAt: json['created_at'] != null
        ? DateTime.parse(json['created_at'] as String)
        : null,
  );

  Map<String, dynamic> toJson() => {
    'customer_name': customerName,
    'customer_phone': customerPhone,
    'customer_address': customerAddress,
    'total_amount': totalAmount,
    'status': status,
    'notes': notes,
  };
}

class OrderItemModel {
  final String? id;
  final String? orderId;
  final String productId;
  final String productName;
  final double productPrice;
  final int quantity;

  const OrderItemModel({
    this.id,
    this.orderId,
    required this.productId,
    required this.productName,
    required this.productPrice,
    required this.quantity,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) => OrderItemModel(
    id: json['id'] as String?,
    orderId: json['order_id'] as String?,
    productId: json['product_id'] as String,
    productName: json['product_name'] as String,
    productPrice: (json['product_price'] as num).toDouble(),
    quantity: json['quantity'] as int,
  );

  Map<String, dynamic> toJson() => {
    'product_id': productId,
    'product_name': productName,
    'product_price': productPrice,
    'quantity': quantity,
  };

  double get subtotal => productPrice * quantity;
}
