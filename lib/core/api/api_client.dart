import 'package:dio/dio.dart';
import 'package:hive/hive.dart';

class ApiClient {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "http://10.0.2.2:1997/api/v1/",
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  //luu token

  Dio get dio => _dio;

  //xoa token khi login :vvv
  void clearToken() {
    final authBox = Hive.box('auth_box');
    authBox.delete('accessToken');
    print('-> [ApiClient]: Đã xóa sạch Token trong Hive.');
  }

  ApiClient() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: ((options, handler) {
          final authBox = Hive.box('auth_box');
          final String? _accessToken = authBox.get('accessToken');

          if (_accessToken != null && _accessToken.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $_accessToken';
            print(
              '-> [Interceptor]: Đã tự động đính kèm Token vào API thành công.',
            );
          } else {
            print("Interceptor có được quoái đâu");
          }
          return handler.next(options);
        }),
        onError: (DioException e, handler) {
          print("Lỗi xuất hiện tại [api err]: ${e.requestOptions.path}");
          print("Mã lỗi: ${e.response?.statusCode}");
          print("Nội dung lỗi: ${e.response?.data}");
          return handler.next(e);
        },
      ),
    );
  }
}

final apiClient = ApiClient();
