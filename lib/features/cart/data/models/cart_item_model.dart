import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/cart_item.dart';
import '../../../product/data/models/product_model.dart';

part 'cart_item_model.g.dart';

@JsonSerializable()
class CartItemModel extends CartItem {
  @override
  final ProductModel product;
  
  const CartItemModel({
    required this.product,
    required super.quantity,
  }) : super(product: product);

  factory CartItemModel.fromJson(Map<String, dynamic> json) =>
      _$CartItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$CartItemModelToJson(this);

  factory CartItemModel.fromCartItem(CartItem cartItem) {
    return CartItemModel(
      product: cartItem.product as ProductModel,
      quantity: cartItem.quantity,
    );
  }
}