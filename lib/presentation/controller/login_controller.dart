import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trips/presentation/controller/login_validator.dart';
import 'package:trips/presentation/controller/login_state.dart';

class LoginController extends Notifier<LoginState> {
  @override
  LoginState build() => LoginState.initial();

  void setEmail(String value) {
    state = state.copyWith(email: value);
    if (state.emailError != null) {
      state = state.copyWith(emailError: null);
    }
  }

  void setPassword(String value) {
    state = state.copyWith(password: value);
    if (state.passwordError != null) {
      state = state.copyWith(passwordError: null);
    }
  }

  void toggleObscure() {
    state = state.copyWith(obscurePassword: !state.obscurePassword);
  }

  void setRememberMe(bool value) {
    state = state.copyWith(rememberMe: value);
  }

  bool validate() {
    final emailError = Validators.validateEmail(state.email);
    final passwordError = Validators.validatePassword(state.password);

    state = state.copyWith(
      emailError: emailError,
      passwordError: passwordError,
    );

    return emailError == null && passwordError == null;
  }

  void setLoading(bool loading) {
    state = state.copyWith(isLoading: loading);
  }

  void prefilledData(String? email, String? password) {
    if (email != null) {
      state = state.copyWith(email: email);
    }
    if (password != null) {
      state = state.copyWith(password: password);
    }
  }

  void reset() {
    state = LoginState.initial();
  }
}

final loginProvider = NotifierProvider<LoginController, LoginState>(
      () => LoginController(),
);