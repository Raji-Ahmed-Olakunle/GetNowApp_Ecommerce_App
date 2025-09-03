import '../entities/onboard_message.dart';

abstract class OnboardingRepository {
  Future<List<OnBoardMessage>> getOnboardingMessages();
} 