import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/onboarding_local_datasource.dart';
import '../../data/repositories/onboarding_repository_impl.dart';
import '../../domain/usecases/get_onboarding_messages.dart';

final onboardingLocalDatasourceProvider = Provider((ref) => OnboardingLocalDatasource());
final onboardingRepositoryProvider = Provider((ref) => OnboardingRepositoryImpl(ref.read(onboardingLocalDatasourceProvider)));
final getOnboardingMessagesUseCaseProvider = Provider((ref) => GetOnboardingMessages(ref.read(onboardingRepositoryProvider))); 