import 'package:bloc_cubit1/features/auth/data/models/auth_response_model.dart';
import 'package:bloc_cubit1/features/auth/domain/repositories/auth_repository.dart';

class LoginUsecase {
  final AuthRepository _repo;
  LoginUsecase(this._repo);
  Future<AuthResponseModel> call({
    required String username,
    required String password,
  }) async {
    return await _repo.login(username: username, password: password);
  }
}
