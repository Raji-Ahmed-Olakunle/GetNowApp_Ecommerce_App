import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class FetchAuthDetails {
  final AuthRepository repository;
  FetchAuthDetails(this.repository);

  Future<User?> call() => repository.fetchAuthDetails();
} 