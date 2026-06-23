import 'package:bloc_cubit1/features/auth/domain/usecases/login_usecase.dart';
import 'package:bloc_cubit1/features/auth/presentation/cubit/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUsecase _login;
  AuthCubit({required LoginUsecase login})
    : _login = login,
      super(AuthInitial());
  String name = '';
  String pass = '';
  void changeName(String value) {
    name = value;
  }

  void changePass(String value) {
    pass = value;
  }

  Future<void> login() async {
    if (name.isEmpty || pass.isEmpty) {
      emit(AuthError("Vui lòng nhập lại tại khoản mật khẩu"));
      return;
    }
    emit(AuthLoading());

    try {
      await _login(username: name, password: pass);
      emit(AuthSuccess());
    } catch (e) {
      emit(AuthError("Đăng nhập thất bại"));
    }
  }
}
