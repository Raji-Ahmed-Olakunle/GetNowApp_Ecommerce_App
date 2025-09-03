import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/user.dart';
import '../../domain/usecases/fetch_auth_details.dart';
import '../../domain/usecases/sign_in.dart';
import '../../domain/usecases/sign_in_with_google.dart';
import '../../domain/usecases/sign_out.dart';
import '../../domain/usecases/sign_up.dart';
import 'auth_usecase_providers.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AsyncValue<User?>>(
  (ref) => AuthNotifier(
    ref.read(signInUseCaseProvider),
    ref.read(signUpUseCaseProvider),
    ref.read(signOutUseCaseProvider),
    ref.read(fetchAuthDetailsUseCaseProvider),
    ref.read(signInWithGoogleUsecaseProvider),
  ),
);

class AuthNotifier extends StateNotifier<AsyncValue<User?>> {
  final SignIn signInUseCase;
  final SignUp signUpUseCase;
  final SignOut signOutUseCase;
  final FetchAuthDetails fetchAuthDetailsUseCase;
  final SignInWithGoogle signInWithGoogleUseCase;

  // Removed ProviderReference _ref;

  Timer? _authTimer;

  AuthNotifier(
    this.signInUseCase,
    this.signUpUseCase,
    this.signOutUseCase,
    this.fetchAuthDetailsUseCase,
    this.signInWithGoogleUseCase,
  ) : super(const AsyncValue.data(null));

  void _startAutoLogout(DateTime? expiryDate) {
    _authTimer?.cancel();

    if (expiryDate == null) return;
    final timeToExpiry = expiryDate.difference(DateTime.now()).inSeconds;
    if (timeToExpiry > 0) {
      _authTimer = Timer(Duration(seconds: timeToExpiry), () async {
        await signOut();
      });
    } else {
      signOut();
    }
  }

  @override
  void dispose() {
    _authTimer?.cancel();
    super.dispose();
  }

  Future<void> signIn(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final user = await signInUseCase(email, password);
      state = AsyncValue.data(user);
      _startAutoLogout(user.expiryDate);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> signUp(String email, String password, String displayname) async {
    state = const AsyncValue.loading();
    try {
      final user = await signUpUseCase(email, password, displayname);
      state = AsyncValue.data(user);
      _startAutoLogout(user.expiryDate);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> signOut() async {
    _authTimer?.cancel();
    await signOutUseCase();
    state = const AsyncValue.data(null);
    print("signOut completeley");
  }

  Future<User?> fetchAuthDetails() async {
    print('inhereeee');
    // state = const AsyncValue.loading();
    try {
      final user = await fetchAuthDetailsUseCase();

      state = AsyncValue.data(user);

      if (user != null) _startAutoLogout(user.expiryDate);

      return state.value;
    } catch (e, st) {
      print(e);
      print(st);
      state = AsyncValue.error(e, st);
      //return null;
    }
    print('dsfd');
  }

  Future<void> sendPasswordResetEmail(String email, WidgetRef ref) async {
    state = const AsyncValue.loading();
    try {
      final useCase = ref.read(sendPasswordResetEmailUseCaseProvider);
      await useCase(email);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> signInWithGoogle() async {
    state = const AsyncValue.loading();
    try {
      final user = await signInWithGoogleUseCase();
      state = AsyncValue.data(user);
      _startAutoLogout(user.expiryDate);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  // Add Google Sign-In and auto-logout as needed, using the repository directly or via new usecases
}
