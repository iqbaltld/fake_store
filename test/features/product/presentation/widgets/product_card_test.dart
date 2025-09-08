import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fake_store/features/product/presentation/widgets/product_card.dart';
import '../../../../helpers/test_constants.dart';

void main() {
  Widget makeTestableWidget(Widget body) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) {
        return MaterialApp(
          home: Scaffold(body: body),
        );
      },
    );
  }

  group('ProductCard Widget Tests', () {
    testWidgets('should display product title', (WidgetTester tester) async {
      // arrange
      await tester.pumpWidget(
        makeTestableWidget(
          ProductCard(
            product: testProduct,
            onTap: () {},
          ),
        ),
      );

      // assert
      expect(find.text(testProduct.title), findsOneWidget);
    });

    testWidgets('should handle tap events', (WidgetTester tester) async {
      // arrange
      bool tapped = false;
      await tester.pumpWidget(
        makeTestableWidget(
          ProductCard(
            product: testProduct,
            onTap: () => tapped = true,
          ),
        ),
      );

      // act
      await tester.tap(find.byType(InkWell));
      await tester.pump();

      // assert
      expect(tapped, true);
    });

    testWidgets('should display card structure', (WidgetTester tester) async {
      // arrange
      await tester.pumpWidget(
        makeTestableWidget(
          ProductCard(
            product: testProduct,
            onTap: () {},
          ),
        ),
      );

      // assert
      expect(find.byType(Card), findsOneWidget);
      expect(find.byType(InkWell), findsOneWidget);
    });
  });
}