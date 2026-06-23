import 'package:bloc_cubit1/features/auth/data/models/auth_response_model.dart';

abstract class AuthRepository {
  Future<AuthResponseModel> login({
    required String username,
    required String password,
  });
}
