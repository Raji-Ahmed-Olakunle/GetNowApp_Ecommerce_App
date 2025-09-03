import '../entities/profile.dart';
import '../repositories/profile_repository.dart';

class LoadProfile {
  final ProfileRepository repository;

  LoadProfile(this.repository);

  Future<Profile> call() => repository.loadProfile();
}
