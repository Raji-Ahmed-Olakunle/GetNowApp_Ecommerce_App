import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getnowshopapp/FeatureMigrated/profile/data/models/profile_model.dart';

import '../../domain/entities/profile.dart';
import '../../domain/usecases/get_profile.dart';
import '../../domain/usecases/load_profile.dart';
import '../../domain/usecases/update_profile.dart';
import 'profile_usecase_providers.dart';

final profileProvider =
    StateNotifierProvider<ProfileNotifier, AsyncValue<Profile>>(
      // expects {'userId': ..., 'token': ...}
      (ref) => ProfileNotifier(
        ref.read(getProfileUseCaseProvider),
        ref.read(updateProfileUseCaseProvider),
        ref.read(loadProfileUsecaseProvider),
      ),
    );

class ProfileNotifier extends StateNotifier<AsyncValue<Profile>> {
  final GetProfile getProfileUseCase;
  final UpdateProfile updateProfileUseCase;
  final LoadProfile loadProfileUseCase;

  ProfileNotifier(
    this.getProfileUseCase,
    this.updateProfileUseCase,
    this.loadProfileUseCase,
  ) : super(const AsyncValue.loading()) {
    loadProfile();
  }

  Future<void> loadProfile() async {
    state = const AsyncValue.loading();
    try {
      final profile = await loadProfileUseCase();
      state = AsyncValue.data(profile);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      print(e);
      print(st);
    }
  }

  Future<Profile?> getProfile(String id) async {
    //state = const AsyncValue.loading();
    try {
      final profile = await getProfileUseCase(id);
      state = AsyncValue.data(profile);
      print(state.value?.imageUrl);
      print('got');

      return state.value;
    } catch (e, st) {
      state = AsyncValue.error(e, st);

      print(e);
      print(st);
    }
  }

  Future<void> updateProfile(ProfileModel profile) async {
    await updateProfileUseCase(profile);
    await loadProfile();
  }
}
