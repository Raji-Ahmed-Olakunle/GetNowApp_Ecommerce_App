import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/usecases/fetch_auth_details.dart';
import '../../domain/usecases/send_password_reset_email.dart';
import '../../domain/usecases/sign_in.dart';
import '../../domain/usecases/sign_in_with_google.dart';
import '../../domain/usecases/sign_out.dart';
import '../../domain/usecases/sign_up.dart';

final authRepositoryProvider = Provider((ref) => AuthRepositoryImpl(ref: ref));

final signInUseCaseProvider = Provider(
      (ref) => SignIn(ref.read(authRepositoryProvider)),
);
final signUpUseCaseProvider = Provider(
      (ref) => SignUp(ref.read(authRepositoryProvider)),
);
final signOutUseCaseProvider = Provider(
      (ref) => SignOut(ref.read(authRepositoryProvider)),
);
final fetchAuthDetailsUseCaseProvider = Provider(
      (ref) => FetchAuthDetails(ref.read(authRepositoryProvider)),
);
final sendPasswordResetEmailUseCaseProvider = Provider(
      (ref) => sendPasswordResetemail(ref.read(authRepositoryProvider)),
);
final signInWithGoogleUsecaseProvider = Provider(
      (ref) => SignInWithGoogle(ref.read(authRepositoryProvider)),
);
