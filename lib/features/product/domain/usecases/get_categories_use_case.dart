import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../repositories/product_repository.dart';

@LazySingleton()
class GetCategoriesUseCase {
  final ProductRepository productRepository;

  GetCategoriesUseCase(this.productRepository);

  Future<Either<Failure, List<String>>> call() async {
    return await productRepository.getCategories();
  }
}