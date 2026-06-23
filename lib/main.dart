import 'package:bloc_cubit1/core/di/injection_container.dart';
import 'package:bloc_cubit1/features/auth/presentation/pages/login_page.dart';
import 'package:bloc_cubit1/features/food/presentation/cubit/fruit_cubit.dart';
import 'package:bloc_cubit1/features/food/presentation/pages/fruit_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('auth_box');
  setupDependence();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (context) => s1<FruitCubit>()..load(),
        //FruitCubit(createF: createF, deleteF: deleteF, getF: getF, searchF: searchF, updateF: updateF),
        child: const FruitListPage(),
      ),
      // home: LoginPage(),
    );
  }
}
