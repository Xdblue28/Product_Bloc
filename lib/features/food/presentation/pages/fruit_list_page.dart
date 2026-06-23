import 'package:bloc_cubit1/features/food/presentation/cubit/fruit_cubit.dart';
import 'package:bloc_cubit1/features/food/presentation/cubit/fruit_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FruitListPage extends StatelessWidget {
  const FruitListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Day la cubit")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              textInputAction: TextInputAction.search,
              onSubmitted: (query) {
                context.read<FruitCubit>().search(query);
              },
              decoration: InputDecoration(
                hintText: "Nhập trái cây bạn muốn tìm...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<FruitCubit, FruitState>(
              builder: (context, state) {
                if (state is FruitLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is FruitFailure) {
                  return const Center(child: Text('Lỗi dữ liệu'));
                }
                if (state is FruitSuccess) {
                  return Center(
                    child: ListView.builder(
                      itemCount: state.fruits.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: const EdgeInsets.all(16.0),
                          child: ListTile(
                            leading: const CircleAvatar(
                              backgroundColor: Colors.orangeAccent,
                              child: Icon(Icons.apple),
                            ),
                            title: Text(
                              state.fruits[index].name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              "Gia: ${state.fruits[index].price}    Quốc gia: ${state.fruits[index].country}",
                            ),
                            trailing: SizedBox(
                              width: 96,
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      context.read<FruitCubit>().delete(
                                        state.fruits[index].id,
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      context.read<FruitCubit>().showEditDialog(
                                        context,
                                        state.fruits[index],
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.app_registration_sharp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
          FloatingActionButton(
            onPressed: () => context.read<FruitCubit>().showAddDialog(context),
            child: Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
