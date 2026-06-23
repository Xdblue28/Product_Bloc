import 'package:bloc_cubit1/features/food/domain/entities/fruit.dart';
import 'package:bloc_cubit1/features/food/domain/repositories/fruit_repository.dart';

class FruitRepositoryImpl implements FruitRepository {
  List<Fruit> dsSP = [
    Fruit(
      id: 'FR001',
      name: 'Táo Rockit New Zealand',
      price: 120000.0,
      country: 'New Zealand',
    ),
    Fruit(
      id: 'FR002',
      name: 'Nho Mẫu Đơn (Shine Muscat)',
      price: 450000.0,
      country: 'Hàn Quốc',
    ),
    Fruit(
      id: 'FR003',
      name: 'Việt Quất Mỹ (Blueberry)',
      price: 85000.0,
      country: 'Mỹ',
    ),
    Fruit(id: 'FR004', name: 'Cam Vàng Navel', price: 65000.0, country: 'Úc'),
    Fruit(
      id: 'FR005',
      name: 'Cherry Đỏ Mỹ (Size 9.5)',
      price: 380000.0,
      country: 'Mỹ',
    ),
  ];
  @override
  Future<void> create(Fruit fruit) {
    dsSP.add(fruit);
    return Future.value();
  }

  @override
  Future<void> delete(String id) {
    dsSP.removeWhere((item) => item.id == id);
    return Future.value();
  }

  @override
  Future<List<Fruit>> getAll() async {
    return List.unmodifiable(dsSP);
  }

  @override
  Future<List<Fruit>> searchFruit(String query) async {
    return dsSP.where((item) {
      final tenSP = item.name.toLowerCase();
      final tenSPtim = query.toLowerCase();
      return tenSP.contains(tenSPtim);
    }).toList();
  }

  @override
  Future<void> update(Fruit fruit) {
    final index = dsSP.indexWhere((item) => item.id == fruit.id);
    if (index != -1) dsSP[index] = fruit;
    return Future.value();
  }
}
