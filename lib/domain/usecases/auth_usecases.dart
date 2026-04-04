import 'package:trips/data/models/user.dart';
import 'package:trips/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;
  LoginUseCase(this.repository);
  Future<User?> execute(String email, String password) =>
      repository.login(email, password);
}

class RegisterUseCase {
  final AuthRepository repository;
  RegisterUseCase(this.repository);
  Future<User?> execute(User user) => repository.register(user);
}

class LogoutUseCase {
  final AuthRepository repository;
  LogoutUseCase(this.repository);
  Future<void> execute() => repository.logout();
}
