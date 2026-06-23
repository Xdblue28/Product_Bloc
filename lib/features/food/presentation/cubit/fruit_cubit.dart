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
    } catch (e) {
      emit(FruitFailure());
    }
  }

  void showAddDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    final countryController = TextEditingController();
    final fruitCubit = this;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return BlocProvider.value(
          value: fruitCubit,
          child: BlocBuilder<FruitCubit, FruitState>(
            builder: (context, state) {
              final isLoading = state is FruitLoading;

              return AlertDialog(
                title: const Text("Thêm Trái Cây Mới"),
                content: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: nameController,
                        enabled: !isLoading,
                        decoration: const InputDecoration(
                          labelText: "Tên trái cây *",
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Tên không được để trống";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: priceController,
                        enabled: !isLoading,
                        decoration: const InputDecoration(
                          labelText: "Giá tiền *",
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Giá không được để trống";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: countryController,
                        enabled: !isLoading,
                        decoration: const InputDecoration(
                          labelText: "Quốc gia *",
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Quốc gia không được để trống";
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                actions: [
                  // --- NÚT HỦY ---
                  Builder(
                    builder: (context) {
                      if (isLoading) {
                        // Nếu đang loading thì trả về nút bị khóa (onPressed: null)
                        return TextButton(
                          onPressed: null,
                          child: const Text("Hủy"),
                        );
                      } else {
                        // Nếu không loading thì cho phép bấm để tắt dialog
                        return TextButton(
                          onPressed: () {
                            Navigator.pop(dialogContext);
                          },
                          child: const Text("Hủy"),
                        );
                      }
                    },
                  ),

                  Builder(
                    builder: (context) {
                      if (isLoading) {
                        return ElevatedButton(
                          onPressed: null,
                          child: const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        );
                      } else {
                        return ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              FocusScope.of(context).unfocus();

                              final newFruit = Fruit(
                                id: '',
                                name: nameController.text.trim(),
                                price:
                                    double.tryParse(
                                      priceController.text.trim(),
                                    ) ??
                                    0,
                                country: countryController.text.trim(),
                              );

                              fruitCubit.create(newFruit);
                              Navigator.pop(dialogContext);
                            }
                          },
                          child: const Text("Thêm"),
                        );
                      }
                    },
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  void showEditDialog(BuildContext context, Fruit fruit) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: fruit.name);
    final priceController = TextEditingController(text: fruit.price.toString());
    final countryController = TextEditingController(text: fruit.country);

    final fruitCubit = this;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return BlocProvider.value(
          value: fruitCubit,
          child: BlocBuilder<FruitCubit, FruitState>(
            builder: (context, state) {
              final isLoading = state is FruitLoading;

              return AlertDialog(
                title: const Text("Cập Nhật Trái Cây"),
                content: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: nameController,
                        enabled: !isLoading,
                        decoration: const InputDecoration(
                          labelText: "Tên trái cây *",
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Tên không được để trống";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: priceController,
                        enabled: !isLoading,
                        decoration: const InputDecoration(
                          labelText: "Giá tiền *",
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Giá không được để trống";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: countryController,
                        enabled: !isLoading,
                        decoration: const InputDecoration(
                          labelText: "Quốc gia *",
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Quốc gia không được để trống";
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                actions: [
                  Builder(
                    builder: (context) {
                      if (isLoading) {
                        return TextButton(
                          onPressed: null,
                          child: const Text("Hủy"),
                        );
                      } else {
                        return TextButton(
                          onPressed: () {
                            Navigator.pop(dialogContext);
                          },
                          child: const Text("Hủy"),
                        );
                      }
                    },
                  ),

                  Builder(
                    builder: (context) {
                      if (isLoading) {
                        return ElevatedButton(
                          onPressed: null,
                          child: const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        );
                      } else {
                        return ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              FocusScope.of(context).unfocus();

                              final updatedFruit = Fruit(
                                id: fruit.id,
                                name: nameController.text.trim(),
                                price:
                                    double.tryParse(
                                      priceController.text.trim(),
                                    ) ??
                                    0,
                                country: countryController.text.trim(),
                              );

                              fruitCubit.updateFruit(updatedFruit);
                              Navigator.pop(dialogContext);
                            }
                          },
                          child: const Text("Cập nhật"),
                        );
                      }
                    },
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
