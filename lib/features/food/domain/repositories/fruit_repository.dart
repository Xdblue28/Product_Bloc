import 'package:bloc_cubit1/features/food/domain/entities/fruit.dart';

abstract interface class FruitRepository {
  Future<void> create(Fruit fruit);
  Future<void> delete(String id);
  Future<void> update(Fruit fruit);
  Future<List<Fruit>> getAll();
  Future<List<Fruit>> searchFruit(String query);
}
