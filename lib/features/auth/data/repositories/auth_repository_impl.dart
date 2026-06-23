import 'package:bloc_cubit1/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:bloc_cubit1/features/auth/data/models/auth_response_model.dart';
import 'package:bloc_cubit1/features/auth/domain/repositories/auth_repository.dart';
import 'package:hive/hive.dart';

class AuthRepositoryImpl implements AuthRepository {
  // gọi thằng gọi api login
  // final AuthRemoteDataSource remoteDataSource = AuthRemoteDataSource();
  final AuthRemoteDataSource remoteDataSource;
  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<AuthResponseModel> login({
    required String username,
    required String password,
  }) async {
    try {
      final authModel = await remoteDataSource.login(
        username: username,
        password: password,
      );

      final authBox = Hive.box('auth_box');
      await authBox.put('accessToken', authModel.accessToken);
      print('-> [Repository Impl]: Đã lưu Token thành công vào ApiClient.');
      return authModel;
    } catch (e) {
      print(" Lỗi thực tế là gì: $e");
      print(" Lỗi xảy ra ở đâu: $StackTrace");
      rethrow;
    }
  }
}
