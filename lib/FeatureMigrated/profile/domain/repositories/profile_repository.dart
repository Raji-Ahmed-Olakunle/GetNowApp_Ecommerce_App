import '../entities/profile.dart';

abstract class ProfileRepository {
  Future<Profile> loadProfile();

  Future<Profile> getProfile(String profile);

  Future<void> updateProfile(Profile profile);
}
