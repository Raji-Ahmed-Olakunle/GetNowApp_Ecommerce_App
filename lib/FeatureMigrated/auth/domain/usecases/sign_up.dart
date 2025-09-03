import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class SignUp {
  final AuthRepository repository;

  SignUp(this.repository);

  Future<User> call(String email, String password, String displayname) =>
      repository.signUp(email, password, displayname);
}
