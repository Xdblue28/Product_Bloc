import 'package:bloc_cubit1/features/food/domain/entities/fruit.dart';
import 'package:bloc_cubit1/features/food/domain/repositories/fruit_repository.dart';

class UpdateFruitUsecase {
  FruitRepository _repo;
  UpdateFruitUsecase(this._repo);
  Future<void> call(Fruit fruit) async {
    return _repo.update(fruit);
  }
}
