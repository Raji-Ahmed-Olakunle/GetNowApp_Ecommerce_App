import '../../domain/entities/onboard_message.dart';
import '../../domain/repositories/onboarding_repository.dart';
import '../datasources/onboarding_local_datasource.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  final OnboardingLocalDatasource localDatasource;
  OnboardingRepositoryImpl(this.localDatasource);

  @override
  Future<List<OnBoardMessage>> getOnboardingMessages() async {
    return localDatasource.getOnboardingMessages();
  }
} 