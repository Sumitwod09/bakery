class CartItemModel {
  final String productId;
  final String productName;
  final double productPrice;
  final String productImage;
  final int quantity;

  const CartItemModel({
    required this.productId,
    required this.productName,
    required this.productPrice,
    required this.productImage,
    required this.quantity,
  });

  double get subtotal => productPrice * quantity;

  CartItemModel copyWith({int? quantity}) => CartItemModel(
    productId: productId,
    productName: productName,
    productPrice: productPrice,
    productImage: productImage,
    quantity: quantity ?? this.quantity,
  );

  @override
  bool operator ==(Object other) =>
      other is CartItemModel && other.productId == productId;

  @override
  int get hashCode => productId.hashCode;
}
