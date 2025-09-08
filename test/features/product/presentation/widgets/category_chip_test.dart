import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fake_store/features/product/presentation/widgets/category_chip.dart';

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

  group('CategoryChip Widget Tests', () {
    testWidgets('should display category label correctly', (WidgetTester tester) async {
      // arrange
      const testLabel = 'Electronics';
      
      await tester.pumpWidget(
        makeTestableWidget(
          CategoryChip(
            label: testLabel,
            isSelected: false,
            onTap: () {},
          ),
        ),
      );

      // assert
      expect(find.text(testLabel), findsOneWidget);
    });

    testWidgets('should handle tap events', (WidgetTester tester) async {
      // arrange
      bool tapped = false;
      
      await tester.pumpWidget(
        makeTestableWidget(
          CategoryChip(
            label: 'Test Category',
            isSelected: false,
            onTap: () => tapped = true,
          ),
        ),
      );

      // act
      await tester.tap(find.byType(CategoryChip));
      await tester.pump();

      // assert
      expect(tapped, true);
    });

    testWidgets('should display category chip widget', (WidgetTester tester) async {
      // arrange
      await tester.pumpWidget(
        makeTestableWidget(
          CategoryChip(
            label: 'Test Category',
            isSelected: true,
            onTap: () {},
          ),
        ),
      );

      // assert
      expect(find.byType(CategoryChip), findsOneWidget);
      expect(find.text('Test Category'), findsOneWidget);
    });
  });
}