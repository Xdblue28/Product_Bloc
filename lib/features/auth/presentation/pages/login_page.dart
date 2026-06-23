import 'package:bloc_cubit1/core/di/injection_container.dart';
import 'package:bloc_cubit1/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:bloc_cubit1/features/auth/presentation/cubit/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(title: Text("Đây là form login test")),
      body: BlocProvider(
        create: (context) => s1<AuthCubit>(),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: BlocConsumer<AuthCubit, AuthState>(
            builder: (context, state) {
              return Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      onChanged: context.read<AuthCubit>().changeName,
                      decoration: InputDecoration(
                        labelText: "Nhập tài khoản hoặc email:",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      onChanged: context.read<AuthCubit>().changePass,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Nhập mật khẩu",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null && value!.trim().isEmpty) {
                          return "Mật khẩu không được để trống";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: LayoutBuilder(
                        builder: (context, contraints) {
                          if (state is AuthLoading) {
                            return Center(child: CircularProgressIndicator());
                          }
                          return ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                context.read<AuthCubit>().login();
                              }
                            },
                            child: Text("Đăng nhập"),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
            listener: (context, state) {
              if (state is AuthSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Đăng nhập thành công")),
                );
              }
              if (state is AuthError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.errorMessage),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
