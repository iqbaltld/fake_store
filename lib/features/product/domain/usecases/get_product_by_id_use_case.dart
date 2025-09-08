import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

@LazySingleton()
class GetProductByIdUseCase {
  final ProductRepository productRepository;

  GetProductByIdUseCase(this.productRepository);

  Future<Either<Failure, Product>> call(int id) async {
    return await productRepository.getProductById(id);
  }
}