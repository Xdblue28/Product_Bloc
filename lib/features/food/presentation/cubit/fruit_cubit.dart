import 'package:bloc_cubit1/features/food/domain/entities/fruit.dart';
import 'package:bloc_cubit1/features/food/domain/usecases/create_fruit_usecase.dart';
import 'package:bloc_cubit1/features/food/domain/usecases/delete_fruit_usecase.dart';
import 'package:bloc_cubit1/features/food/domain/usecases/get_fruits_usecase.dart';
import 'package:bloc_cubit1/features/food/domain/usecases/search_fruits_usecase.dart';
import 'package:bloc_cubit1/features/food/domain/usecases/update_fruit_usecase.dart';
import 'package:bloc_cubit1/features/food/presentation/cubit/fruit_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FruitCubit extends Cubit<FruitState> {
  final CreateFruitUsecase _createF;
  final DeleteFruitUsecase _deleteF;
  final GetFruitsUsecase _getF;
  final SearchFruitsUsecase _searchF;
  final UpdateFruitUsecase _updateF;

  FruitCubit({
    required CreateFruitUsecase createF,
    required DeleteFruitUsecase deleteF,
    required GetFruitsUsecase getF,
    required SearchFruitsUsecase searchF,
    required UpdateFruitUsecase updateF,
  }) : _createF = createF,
       _deleteF = deleteF,
       _getF = getF,
       _searchF = searchF,
       _updateF = updateF,
       super(FruitInitial());

  Future<void> load() async {
    emit(FruitLoading());
    try {
      final fruits = await _getF();
      emit(FruitSuccess(fruits));
    } catch (e) {
      emit(FruitFailure());
    }
  }

  Future<void> create(Fruit fruit) async {
    try {
      await _createF(fruit);
      final updatedFruits = await _getF();
      emit(FruitSuccess(updatedFruits));
    } catch (e) {
      emit(FruitFailure());
    }
  }

  Future<void> delete(String id) async {
    try {
      await _deleteF(id);
      final updatedFruits = await _getF();
      emit(FruitSuccess(updatedFruits));
    } catch (e) {
      emit(FruitFailure());
    }
  }

  Future<void> search(String query) async {
    if (query.isEmpty) {
      await load();
      return;
    }

    emit(FruitLoading());
    try {
      final result = await _searchF(query);
      emit(FruitSuccess(result));
    } catch (e) {
      emit(FruitFailure());
    }
  }

  Future<void> updateFruit(Fruit fruit) async {
    try {
      await _updateF(fruit);
      final updatedFruits = await _getF();

      emit(FruitSuccess(updatedFruits));
      await load();
    } catch (e) {
      emit(FruitFailure());
    }
  }

  void showAddDialog(BuildContext context) {
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    final countryController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Tên trái cây"),
            ),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(labelText: "Giá tiền"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: countryController,
              decoration: const InputDecoration(labelText: "Quốc gia"),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
            },
            child: const Text("Hủy"),
          ),
          ElevatedButton(
            onPressed: () {
              final newFruit = Fruit(
                id: '',
                name: nameController.text,
                price: double.tryParse(priceController.text) ?? 0,
                country: countryController.text,
              );
              context.read<FruitCubit>().create(newFruit);
              Navigator.pop(dialogContext);
            },
            child: Text("Thêm"),
          ),
        ],
      ),
    );
  }

  void showEditDialog(BuildContext context, Fruit fruit) {
    final nameController = TextEditingController(text: fruit.name);
    final priceController = TextEditingController(text: fruit.price.toString());
    final countryController = TextEditingController(text: fruit.country);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Tên trái cây"),
            ),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(labelText: "Giá tiền"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: countryController,
              decoration: const InputDecoration(labelText: "Quốc gia"),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text("Hủy"),
          ),
          ElevatedButton(
            onPressed: () {
              final updatedFruit = Fruit(
                id: fruit.id,
                name: nameController.text,
                price: double.tryParse(priceController.text) ?? 0,
                country: countryController.text,
              );

              context.read<FruitCubit>().updateFruit(updatedFruit);

              Navigator.pop(dialogContext);
            },
            child: const Text("Cập nhật"),
          ),
        ],
      ),
    );
  }
}
