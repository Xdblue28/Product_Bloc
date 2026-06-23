import 'package:bloc_cubit1/core/api/api_client.dart';
import 'package:bloc_cubit1/features/auth/data/models/auth_response_model.dart';
import 'package:dio/dio.dart';

class AuthRemoteDataSource {
  Future<AuthResponseModel> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await apiClient.dio.post(
        'login',
        data: {'username': username, 'password': password},
      );
      print(
        '-> [DataSource]: Đăng nhập thành công, đang nạp dữ liệu vào Model...',
      );
      return AuthResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      print('-> [DataSource Error]: Gọi API Login thất bại: ${e.message}');
      rethrow;
    } catch (e) {
      print("Lỗi hệ thống: $e");
      rethrow;
    }
  }
}
