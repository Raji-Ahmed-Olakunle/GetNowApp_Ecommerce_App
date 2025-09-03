import '../entities/user.dart';

abstract class AuthRepository {
  Future<User> signIn(String email, String password);

  Future<User> signUp(String email, String password, String DisplayName);

  Future<User> signInWithGoogle();

  Future<void> signOut();

  Future<void> autoLogout(Duration duration);

  Future<User?> fetchAuthDetails();

  Future<void> localStorage({
    required String token,
    required String userId,
    required DateTime expiryDate,
  });

  Future<void> sendPasswordResetEmail(String email);
}
