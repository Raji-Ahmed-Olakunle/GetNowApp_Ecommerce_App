import '../repositories/auth_repository.dart';

class sendPasswordResetemail {
  final AuthRepository repository;

  sendPasswordResetemail(this.repository);

  Future<void> call(String email) => repository.sendPasswordResetEmail(email);
}
