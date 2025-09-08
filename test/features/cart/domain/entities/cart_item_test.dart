import 'package:flutter_test/flutter_test.dart';
import 'package:fake_store/features/cart/domain/entities/cart_item.dart';
import '../../../../helpers/test_constants.dart';

void main() {
  group('CartItem Entity', () {
    test('should be a subclass of Equatable', () {
      // assert
      expect(testCartItem, isA<CartItem>());
    });

    test('should have correct properties', () {
      // assert
      expect(testCartItem.product, testProduct);
      expect(testCartItem.quantity, 2);
    });

    test('should calculate correct total price', () {
      // assert
      expect(testCartItem.totalPrice, 109.95 * 2);
      expect(testCartItem2.totalPrice, 22.3 * 1);
    });

    test('should support value equality', () {
      // arrange
      const testCartItem2 = CartItem(
        product: testProduct,
        quantity: 2,
      );

      // assert
      expect(testCartItem, equals(testCartItem2));
      expect(testCartItem.hashCode, equals(testCartItem2.hashCode));
    });

    test('should not be equal for different properties', () {
      // arrange
      const differentCartItem = CartItem(
        product: testProduct,
        quantity: 3,
      );

      // assert
      expect(testCartItem, isNot(equals(differentCartItem)));
    });

    group('copyWith', () {
      test('should return same object when no parameters provided', () {
        // act
        final result = testCartItem.copyWith();

        // assert
        expect(result, equals(testCartItem));
      });

      test('should return updated object when quantity provided', () {
        // act
        final result = testCartItem.copyWith(quantity: 5);

        // assert
        expect(result.quantity, 5);
        expect(result.product, testCartItem.product);
        expect(result, isNot(equals(testCartItem)));
      });

      test('should return updated object when product provided', () {
        // act
        final result = testCartItem.copyWith(product: testProduct2);

        // assert
        expect(result.product, testProduct2);
        expect(result.quantity, testCartItem.quantity);
        expect(result, isNot(equals(testCartItem)));
      });

      test('should return updated object when both parameters provided', () {
        // act
        final result = testCartItem.copyWith(
          product: testProduct2,
          quantity: 3,
        );

        // assert
        expect(result.product, testProduct2);
        expect(result.quantity, 3);
        expect(result, isNot(equals(testCartItem)));
      });
    });
  });
}