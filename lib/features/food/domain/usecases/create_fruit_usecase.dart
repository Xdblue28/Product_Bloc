import 'package:bloc_cubit1/features/food/domain/entities/fruit.dart';
import 'package:bloc_cubit1/features/food/domain/repositories/fruit_repository.dart';

class CreateFruitUsecase {
  FruitRepository _repo;
  CreateFruitUsecase(this._repo);
  Future<void> call(Fruit fruit) async {
    await _repo.create(fruit);
  }
}
