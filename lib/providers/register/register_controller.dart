// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:trips/helpers/login_validator.dart';
// import 'package:trips/models/country_code.dart';
// import 'package:trips/providers/register/register_state.dart';
//
// class RegisterController extends Notifier<RegisterState> {
//   @override
//   RegisterState build() => RegisterState.initial();
//
//   void setName(String value) {
//     state = state.copyWith(name: value);
//     if (state.nameError != null) {
//       state = state.copyWith(nameError: null);
//     }
//   }
//
//   void setEmail(String value) {
//     state = state.copyWith(email: value);
//     if (state.emailError != null) {
//       state = state.copyWith(emailError: null);
//     }
//   }
//
//   void setPhone(String value) {
//     state = state.copyWith(phone: value);
//     if (state.phoneError != null) {
//       state = state.copyWith(phoneError: null);
//     }
//   }
//
//   void setGender(String value) {
//     state = state.copyWith(gender: value);
//   }
//
//   void setSelectedCountry(CountryCode country) {
//     state = state.copyWith(selectedCountry: country);
//   }
//
//   void setPassword(String value) {
//     state = state.copyWith(password: value);
//     if (state.passwordError != null) {
//       state = state.copyWith(passwordError: null);
//     }
//   }
//
//   void setConfirmPassword(String value) {
//     state = state.copyWith(confirmPassword: value);
//     if (state.confirmPasswordError != null) {
//       state = state.copyWith(confirmPasswordError: null);
//     }
//   }
//
//   void toggleObscurePassword() {
//     state = state.copyWith(obscurePassword: !state.obscurePassword);
//   }
//
//   void toggleObscureConfirmPassword() {
//     state = state.copyWith(obscureConfirmPassword: !state.obscureConfirmPassword);
//   }
//
//   void setLoading(bool loading) {
//     state = state.copyWith(isLoading: loading);
//   }
//
//   bool validate() {
//     final nameError = Validators.validateName(state.name);
//     final emailError = Validators.validateEmail(state.email);
//     final phoneError = Validators.validatePhone(state.phone);
//     final passwordError = Validators.validatePassword(state.password);
//     final confirmPasswordError = Validators.validateConfirmPassword(
//       state.password,
//       state.confirmPassword,
//     );
//
//     state = state.copyWith(
//       nameError: nameError,
//       emailError: emailError,
//       phoneError: phoneError,
//       passwordError: passwordError,
//       confirmPasswordError: confirmPasswordError,
//     );
//
//     return nameError == null &&
//         emailError == null &&
//         phoneError == null &&
//         passwordError == null &&
//         confirmPasswordError == null;
//   }
//
//   void reset() {
//     state = RegisterState.initial();
//   }
// }
//
// final registerProvider = NotifierProvider<RegisterController, RegisterState>(
//       () => RegisterController(),
// );

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trips/helpers/login_validator.dart';
import 'package:trips/models/country_code.dart';
import 'package:trips/models/user.dart';
import 'package:trips/providers/register/register_state.dart';

class RegisterController extends Notifier<RegisterState> {
  @override
  RegisterState build() => RegisterState.initial();

  void setName(String value) {
    state = state.copyWith(name: value);
    if (state.nameError != null) {
      state = state.copyWith(nameError: null);
    }
  }

  void setEmail(String value) {
    state = state.copyWith(email: value);
    if (state.emailError != null) {
      state = state.copyWith(emailError: null);
    }
  }

  void setPhone(String value) {
    state = state.copyWith(phone: value);
    if (state.phoneError != null) {
      state = state.copyWith(phoneError: null);
    }
  }

  void setGender(String value) {
    state = state.copyWith(gender: value);
  }

  void setSelectedCountry(CountryCode country) {
    state = state.copyWith(selectedCountry: country);
  }

  void setPassword(String value) {
    state = state.copyWith(password: value);
    if (state.passwordError != null) {
      state = state.copyWith(passwordError: null);
    }
  }

  void setConfirmPassword(String value) {
    state = state.copyWith(confirmPassword: value);
    if (state.confirmPasswordError != null) {
      state = state.copyWith(confirmPasswordError: null);
    }
  }

  void toggleObscurePassword() {
    state = state.copyWith(obscurePassword: !state.obscurePassword);
  }

  void toggleObscureConfirmPassword() {
    state = state.copyWith(obscureConfirmPassword: !state.obscureConfirmPassword);
  }

  void setLoading(bool loading) {
    state = state.copyWith(isLoading: loading);
  }

  bool validate() {
    final nameError = Validators.validateName(state.name);
    final emailError = Validators.validateEmail(state.email);
    final phoneError = Validators.validatePhone(state.phone);
    final passwordError = Validators.validatePassword(state.password);
    final confirmPasswordError = Validators.validateConfirmPassword(
      state.password,
      state.confirmPassword,
    );

    state = state.copyWith(
      nameError: nameError,
      emailError: emailError,
      phoneError: phoneError,
      passwordError: passwordError,
      confirmPasswordError: confirmPasswordError,
    );

    return nameError == null &&
        emailError == null &&
        phoneError == null &&
        passwordError == null &&
        confirmPasswordError == null;
  }

  void reset() {
    state = RegisterState.initial();
  }
}

final registerProvider = NotifierProvider<RegisterController, RegisterState>(
      () => RegisterController(),
);