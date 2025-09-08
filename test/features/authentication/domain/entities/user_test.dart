import 'package:flutter_test/flutter_test.dart';
import 'package:fake_store/features/authentication/domain/entities/user.dart';
import '../../../../helpers/test_constants.dart';

void main() {
  group('User Entity', () {
    test('should be a subclass of Equatable', () {
      // assert
      expect(testUser, isA<User>());
    });

    test('should have correct properties', () {
      // assert
      expect(testUser.id, 1);
      expect(testUser.email, 'john@gmail.com');
      expect(testUser.username, 'johnd');
      expect(testUser.firstName, 'John');
      expect(testUser.lastName, 'Doe');
      expect(testUser.phone, '1-570-236-7033');
    });

    test('should support value equality', () {
      // arrange
      const testUser2 = User(
        id: 1,
        email: 'john@gmail.com',
        username: 'johnd',
        firstName: 'John',
        lastName: 'Doe',
        phone: '1-570-236-7033',
      );

      // assert
      expect(testUser, equals(testUser2));
      expect(testUser.hashCode, equals(testUser2.hashCode));
    });

    test('should not be equal for different properties', () {
      // arrange
      const differentUser = User(
        id: 2,
        email: 'jane@gmail.com',
        username: 'janed',
        firstName: 'Jane',
        lastName: 'Smith',
        phone: '1-570-236-7034',
      );

      // assert
      expect(testUser, isNot(equals(differentUser)));
    });
  });
}