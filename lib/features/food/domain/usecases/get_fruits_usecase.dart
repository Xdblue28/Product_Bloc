import 'package:bloc_cubit1/features/food/domain/entities/fruit.dart';
import 'package:bloc_cubit1/features/food/domain/repositories/fruit_repository.dart';

class GetFruitsUsecase {
  FruitRepository _repo;
  GetFruitsUsecase(this._repo);
  Future<List<Fruit>> call() async {
    return _repo.getAll();
  }
}
