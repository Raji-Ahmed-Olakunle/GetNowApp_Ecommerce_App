import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/onboard_message.dart';
import '../../domain/usecases/get_onboarding_messages.dart';
import 'onboarding_usecase_providers.dart';

final onboardingProvider = StateNotifierProvider<
  OnboardingNotifier,
  AsyncValue<List<OnBoardMessage>>
>((ref) => OnboardingNotifier(ref.read(getOnboardingMessagesUseCaseProvider)));

class OnboardingNotifier
    extends StateNotifier<AsyncValue<List<OnBoardMessage>>> {
  final GetOnboardingMessages getOnboardingMessagesUseCase;

  OnboardingNotifier(this.getOnboardingMessagesUseCase)
    : super(const AsyncValue.loading()) {
    loadOnboardingMessages();
  }

  Future<void> loadOnboardingMessages() async {
    state = const AsyncValue.loading();
    try {
      final messages = await getOnboardingMessagesUseCase();
      state = AsyncValue.data(messages);
      print(state);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
