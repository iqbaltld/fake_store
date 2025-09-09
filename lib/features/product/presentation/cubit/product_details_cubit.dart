import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:fake_store/features/product/domain/entities/product.dart';
import 'package:fake_store/features/product/domain/usecases/get_product_by_id_use_case.dart';

part 'product_details_state.dart';

@Injectable()
class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  final GetProductByIdUseCase getProductByIdUseCase;

  ProductDetailsCubit(this.getProductByIdUseCase) : super(ProductDetailsInitial());

  Future<void> loadProductDetails(int productId) async {
    print('🔄 ProductDetailsCubit: Loading product $productId');
    if (isClosed) return;
    emit(ProductDetailsLoading());

    final result = await getProductByIdUseCase(productId);
    if (isClosed) return;
    
    result.fold(
      (failure) {
        print('❌ ProductDetailsCubit: Failed to load product $productId: ${failure.message}');
        if (!isClosed) emit(ProductDetailsError(message: failure.message));
      },
      (product) {
        print('✅ ProductDetailsCubit: Successfully loaded product ${product.id}: ${product.title}');
        if (!isClosed) emit(ProductDetailsLoaded(product: product));
      },
    );
  }
}