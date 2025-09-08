import 'package:flutter_test/flutter_test.dart';
import 'package:fake_store/features/product/domain/entities/product.dart';

void main() {
  group('Product Entity', () {
    const testRating = Rating(rate: 4.5, count: 100);
    
    const testProduct = Product(
      id: 1,
      title: 'Test Product',
      price: 99.99,
      description: 'Test Description',
      category: 'test category',
      image: 'test_image.jpg',
      rating: testRating,
    );

    test('should be a subclass of Equatable', () {
      // assert
      expect(testProduct, isA<Product>());
    });

    test('should have correct properties', () {
      // assert
      expect(testProduct.id, 1);
      expect(testProduct.title, 'Test Product');
      expect(testProduct.price, 99.99);
      expect(testProduct.description, 'Test Description');
      expect(testProduct.category, 'test category');
      expect(testProduct.image, 'test_image.jpg');
      expect(testProduct.rating, testRating);
    });

    test('should support value equality', () {
      // arrange
      const testProduct2 = Product(
        id: 1,
        title: 'Test Product',
        price: 99.99,
        description: 'Test Description',
        category: 'test category',
        image: 'test_image.jpg',
        rating: testRating,
      );

      // assert
      expect(testProduct, equals(testProduct2));
      expect(testProduct.hashCode, equals(testProduct2.hashCode));
    });

    test('should not be equal for different properties', () {
      // arrange
      const differentProduct = Product(
        id: 2,
        title: 'Different Product',
        price: 199.99,
        description: 'Different Description',
        category: 'different category',
        image: 'different_image.jpg',
        rating: testRating,
      );

      // assert
      expect(testProduct, isNot(equals(differentProduct)));
    });
  });

  group('Rating Entity', () {
    const testRating = Rating(rate: 4.5, count: 100);

    test('should be a subclass of Equatable', () {
      // assert
      expect(testRating, isA<Rating>());
    });

    test('should have correct properties', () {
      // assert
      expect(testRating.rate, 4.5);
      expect(testRating.count, 100);
    });

    test('should support value equality', () {
      // arrange
      const testRating2 = Rating(rate: 4.5, count: 100);

      // assert
      expect(testRating, equals(testRating2));
      expect(testRating.hashCode, equals(testRating2.hashCode));
    });

    test('should not be equal for different properties', () {
      // arrange
      const differentRating = Rating(rate: 3.5, count: 50);

      // assert
      expect(testRating, isNot(equals(differentRating)));
    });
  });
}