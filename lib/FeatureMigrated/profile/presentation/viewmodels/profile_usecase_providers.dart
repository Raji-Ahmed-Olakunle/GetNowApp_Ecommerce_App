import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/viewmodels/auth_provider.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/usecases/get_profile.dart';
import '../../domain/usecases/load_profile.dart';
import '../../domain/usecases/update_profile.dart';

final profileRepositoryProvider = Provider((ref) {
  final auth = ref.watch(authProvider);
  print(auth);
  final token = auth.value?.token ?? '';
  final userId = auth.value?.id ?? '';
  return ProfileRepositoryImpl(token: token, userId: userId);
});

final getProfileUseCaseProvider = Provider(
  (ref) => GetProfile(ref.read(profileRepositoryProvider)),
);
final updateProfileUseCaseProvider = Provider(
  (ref) => UpdateProfile(ref.read(profileRepositoryProvider)),
);
final loadProfileUsecaseProvider = Provider(
  (ref) => LoadProfile(ref.read(profileRepositoryProvider)),
);
