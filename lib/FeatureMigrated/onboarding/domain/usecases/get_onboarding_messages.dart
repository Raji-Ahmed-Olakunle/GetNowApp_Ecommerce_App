import '../entities/onboard_message.dart';
import '../repositories/onboarding_repository.dart';

class GetOnboardingMessages {
  final OnboardingRepository repository;
  GetOnboardingMessages(this.repository);

  Future<List<OnBoardMessage>> call() => repository.getOnboardingMessages();
} 