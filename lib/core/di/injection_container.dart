import 'package:bloc_cubit1/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:bloc_cubit1/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:bloc_cubit1/features/auth/domain/repositories/auth_repository.dart';
import 'package:bloc_cubit1/features/auth/domain/usecases/login_usecase.dart';
import 'package:bloc_cubit1/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:bloc_cubit1/features/food/data/repositories/fruit_repository_impl.dart';
import 'package:bloc_cubit1/features/food/domain/repositories/fruit_repository.dart';
import 'package:bloc_cubit1/features/food/domain/usecases/create_fruit_usecase.dart';
import 'package:bloc_cubit1/features/food/domain/usecases/delete_fruit_usecase.dart';
import 'package:bloc_cubit1/features/food/domain/usecases/get_fruits_usecase.dart';
import 'package:bloc_cubit1/features/food/domain/usecases/search_fruits_usecase.dart';
import 'package:bloc_cubit1/features/food/domain/usecases/update_fruit_usecase.dart';
import 'package:bloc_cubit1/features/food/presentation/cubit/fruit_cubit.dart';
import 'package:get_it/get_it.dart';

final s1 = GetIt.instance;
void setupDependence() {
  s1.registerLazySingleton<FruitRepository>(() => FruitRepositoryImpl());

  s1.registerLazySingleton(() => GetFruitsUsecase(s1()));
  s1.registerLazySingleton(() => CreateFruitUsecase(s1()));
  s1.registerLazySingleton(() => DeleteFruitUsecase(s1()));
  s1.registerLazySingleton(() => UpdateFruitUsecase(s1()));
  s1.registerLazySingleton(() => SearchFruitsUsecase(s1()));

  s1.registerFactory(
    () => FruitCubit(
      createF: s1(),
      deleteF: s1(),
      getF: s1(),
      searchF: s1(),
      updateF: s1(),
    ),
  );

  s1.registerLazySingleton(() => AuthRemoteDataSource());
  s1.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: s1()),
  );
  s1.registerLazySingleton(() => LoginUsecase(s1()));
  s1.registerFactory(() => AuthCubit(login: s1()));
}
