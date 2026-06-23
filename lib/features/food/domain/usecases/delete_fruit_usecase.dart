import 'package:bloc_cubit1/features/food/domain/repositories/fruit_repository.dart';

class DeleteFruitUsecase {
  FruitRepository _repo;
  DeleteFruitUsecase(this._repo);
  Future<void> call(String id) async {
    return _repo.delete(id);
  }
}
