import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class SignInWithGoogle {
  final AuthRepository repository;

  SignInWithGoogle(this.repository);

  Future<User> call() => repository.signInWithGoogle();
}
