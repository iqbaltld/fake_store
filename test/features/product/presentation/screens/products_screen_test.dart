
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fake_store/features/product/presentation/cubit/products_cubit.dart';
import 'package:fake_store/features/product/presentation/screens/products_screen.dart';
import 'package:fake_store/features/product/presentation/widgets/products_shimmer_grid.dart';
import 'package:fake_store/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:fake_store/core/theme/cubit/theme_cubit.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import '../../../../helpers/test_constants.dart';

class MockProductsCubit extends MockCubit<ProductsState> implements ProductsCubit {}
class MockCartCubit extends MockCubit<CartState> implements CartCubit {}
class MockThemeCubit extends MockCubit<ThemeState> implements ThemeCubit {}

void main() {
  late MockProductsCubit mockProductsCubit;
  late MockCartCubit mockCartCubit;
  late MockThemeCubit mockThemeCubit;

  setUp(() {
    mockProductsCubit = MockProductsCubit();
    mockCartCubit = MockCartCubit();
    mockThemeCubit = MockThemeCubit();
  });

  Widget makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProductsCubit>.value(value: mockProductsCubit),
        BlocProvider<CartCubit>.value(value: mockCartCubit),
        BlocProvider<ThemeCubit>.value(value: mockThemeCubit),
      ],
      child: MaterialApp(
        home: body,
        builder: (context, child) {
          ScreenUtil.init(context, designSize: const Size(360, 690));
          return child!;
        },
      ),
    );
  }

  group('ProductsScreen Widget Tests', () {
    testWidgets('should show loading indicator when products are loading', (WidgetTester tester) async {
      // arrange
      when(() => mockProductsCubit.state).thenReturn(ProductsLoading());
      when(() => mockProductsCubit.loadProducts()).thenAnswer((_) async {});
      when(() => mockCartCubit.state).thenReturn(CartInitial());
      when(() => mockCartCubit.loadCartItems()).thenAnswer((_) async {});
      when(() => mockThemeCubit.state).thenReturn(const ThemeState(themeMode: ThemeMode.light));

      // act
      await tester.pumpWidget(makeTestableWidget(const ProductsScreen()));

      // assert
      expect(find.byType(ProductsShimmerGrid), findsOneWidget);
    });

    testWidgets('should show products when loaded successfully', (WidgetTester tester) async {
      // arrange
      when(() => mockProductsCubit.state).thenReturn(
        ProductsLoaded(
          products: testProducts,
          categories: testCategories,
        ),
      );
      when(() => mockProductsCubit.loadProducts()).thenAnswer((_) async {});
      when(() => mockCartCubit.state).thenReturn(CartInitial());
      when(() => mockCartCubit.loadCartItems()).thenAnswer((_) async {});
      when(() => mockThemeCubit.state).thenReturn(const ThemeState(themeMode: ThemeMode.light));

      // act
      await tester.pumpWidget(makeTestableWidget(const ProductsScreen()));
      await tester.pump();

      // assert
      expect(find.byType(GridView), findsOneWidget);
      expect(find.text(testProduct.title), findsOneWidget);
    });

    testWidgets('should show error message when products fail to load', (WidgetTester tester) async {
      // arrange
      const errorMessage = 'Failed to load products';
      when(() => mockProductsCubit.state).thenReturn(
        const ProductsError(message: errorMessage),
      );
      when(() => mockProductsCubit.loadProducts()).thenAnswer((_) async {});
      when(() => mockCartCubit.state).thenReturn(CartInitial());
      when(() => mockCartCubit.loadCartItems()).thenAnswer((_) async {});
      when(() => mockThemeCubit.state).thenReturn(const ThemeState(themeMode: ThemeMode.light));

      // act
      await tester.pumpWidget(makeTestableWidget(const ProductsScreen()));

      // assert
      expect(find.text(errorMessage), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('should display app bar with correct title', (WidgetTester tester) async {
      // arrange
      when(() => mockProductsCubit.state).thenReturn(ProductsInitial());
      when(() => mockProductsCubit.loadProducts()).thenAnswer((_) async {});
      when(() => mockCartCubit.state).thenReturn(CartInitial());
      when(() => mockCartCubit.loadCartItems()).thenAnswer((_) async {});
      when(() => mockThemeCubit.state).thenReturn(const ThemeState(themeMode: ThemeMode.light));

      // act
      await tester.pumpWidget(makeTestableWidget(const ProductsScreen()));

      // assert
      expect(find.text('Fake Store'), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('should show cart icon in app bar', (WidgetTester tester) async {
      // arrange
      when(() => mockProductsCubit.state).thenReturn(ProductsInitial());
      when(() => mockProductsCubit.loadProducts()).thenAnswer((_) async {});
      when(() => mockCartCubit.state).thenReturn(CartInitial());
      when(() => mockCartCubit.loadCartItems()).thenAnswer((_) async {});
      when(() => mockThemeCubit.state).thenReturn(const ThemeState(themeMode: ThemeMode.light));

      // act
      await tester.pumpWidget(makeTestableWidget(const ProductsScreen()));

      // assert
      expect(find.byIcon(Icons.shopping_cart_outlined), findsOneWidget);
    });

    testWidgets('should show theme toggle icon in app bar', (WidgetTester tester) async {
      // arrange
      when(() => mockProductsCubit.state).thenReturn(ProductsInitial());
      when(() => mockProductsCubit.loadProducts()).thenAnswer((_) async {});
      when(() => mockCartCubit.state).thenReturn(CartInitial());
      when(() => mockCartCubit.loadCartItems()).thenAnswer((_) async {});
      when(() => mockThemeCubit.state).thenReturn(const ThemeState(themeMode: ThemeMode.light));

      // act
      await tester.pumpWidget(makeTestableWidget(const ProductsScreen()));

      // assert
      // Should show dark_mode icon when in light theme
      expect(find.byIcon(Icons.dark_mode), findsOneWidget);
    });
  });
}