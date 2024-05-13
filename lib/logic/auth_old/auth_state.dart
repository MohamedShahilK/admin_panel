part of 'auth_bloc_old.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    required TextEditingController emailController,
    required TextEditingController passwordController,
    required TextEditingController operatorIdController
  }) = _AuthState;

   factory AuthState.initial() => AuthState(
    emailController: TextEditingController(),
    passwordController: TextEditingController(),
    operatorIdController: TextEditingController(),
  );
}
