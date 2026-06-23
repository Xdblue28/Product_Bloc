import 'package:bloc_cubit1/features/food/domain/entities/fruit.dart';
import 'package:bloc_cubit1/features/food/domain/repositories/fruit_repository.dart';

class SearchFruitsUsecase {
  FruitRepository _repo;
  SearchFruitsUsecase(this._repo);
  Future<List<Fruit>> call(String query) async {
    return _repo.searchFruit(query);
  }
}
