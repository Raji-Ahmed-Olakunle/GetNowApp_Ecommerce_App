import 'package:getnowshopapp/FeatureMigrated/profile/data/models/profile_model.dart';

import '../repositories/profile_repository.dart';

class UpdateProfile {
  final ProfileRepository repository;

  UpdateProfile(this.repository);

  Future<void> call(ProfileModel profile) => repository.updateProfile(profile);
}
