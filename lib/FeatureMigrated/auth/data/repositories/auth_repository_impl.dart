import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:getnowshopapp/FeatureMigrated/profile/data/models/profile_model.dart';
import 'package:getnowshopapp/FeatureMigrated/profile/presentation/viewmodels/profile_provider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  var ref;
  Timer? _authTimer;

  AuthRepositoryImpl({required this.ref});

  // Email/Password Sign-In
  @override
  Future<User> signIn(String email, String password) async {
    final fb.FirebaseAuth _firebaseAuth = fb.FirebaseAuth.instance;
    final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final fbUser = userCredential.user!;
    final String? token = await fbUser.getIdToken();
    final expiryDate = DateTime.now().add(Duration(hours: 1)); // Example expiry
    await localStorage(
      token: token!,
      userId: fbUser.uid,
      expiryDate: expiryDate,
    );
    print(token);
    print(fbUser.uid);
    print(expiryDate);
    return UserModel(id: fbUser.uid, email: fbUser.email ?? '', token: token);
  }

  // Email/Password Sign-Up
  @override
  Future<User> signUp(String email, String password, String DisplayName) async {
    final fb.FirebaseAuth _firebaseAuth = fb.FirebaseAuth.instance;
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final fbUser = userCredential.user!;
    final String? token = await fbUser.getIdToken();
    final expiryDate = DateTime.now().add(Duration(hours: 1)); // Example expiry
    await ref
        .read(profileProvider.notifier)
        .updateProfile(
          ProfileModel(id: fbUser.uid, imageUrl: '', name: DisplayName),
        );
    await localStorage(
      token: token!,
      userId: fbUser.uid,
      expiryDate: expiryDate,
    );
    return UserModel(id: fbUser.uid, email: fbUser.email ?? '', token: token);
  }

  // Google Sign-In with Firebase
  @override
  Future<UserModel> signInWithGoogle() async {
    final FirebaseAuth_auth = fb.FirebaseAuth.instance;
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      throw Exception('Google sign-in cancelled');
    }
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final credential = fb.GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final userCredential = await FirebaseAuth_auth.signInWithCredential(
      credential,
    );
    print(userCredential);
    final fbUser = userCredential.user!;
    final token = await fbUser.getIdToken();
    final expiryDate = DateTime.now().add(Duration(hours: 1));
    if (userCredential.additionalUserInfo!.isNewUser) {
      await ref
          .read(profileProvider.notifier)
          .updateProfile(
            ProfileModel(
              id: fbUser.uid,
              imageUrl: fbUser.photoURL,
              name: fbUser.displayName,
            ),
          );
    }
    await localStorage(
      token: token!,
      userId: fbUser.uid,
      expiryDate: expiryDate,
    );
    print('d');
    return UserModel(
      id: fbUser.uid,
      email: fbUser.email ?? '',
      token: token,
      expiryDate: expiryDate,
    );
  }

  // Logout logic
  @override
  Future<void> signOut() async {
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    final prefAccess = await SharedPreferences.getInstance();
    await prefAccess.remove('AuthData');

    await fb.FirebaseAuth.instance.signOut();
  }

  // Auto-logout logic
  @override
  Future<void> autoLogout(Duration duration) async {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    _authTimer = Timer(duration, () async {
      await signOut();
    });
  }

  // Session restore
  @override
  Future<User?> fetchAuthDetails() async {
    final prefAccess = await SharedPreferences.getInstance();
    if (prefAccess.containsKey('AuthData')) {
      Map<String, dynamic> extractedData = json.decode(
        prefAccess.getString('AuthData')!,
      );
      final expiryDate = DateTime.parse(extractedData['expiryDate']);
      print(expiryDate);
      if (expiryDate.isAfter(DateTime.now())) {
        print("is after");
        return User(
          id: extractedData['userId'],
          token: extractedData['token'],
          expiryDate: DateTime.parse(extractedData['expiryDate']),
          email: '',
        );
      }
      print('dfw');
    }

    // return null;
  }

  // Local storage
  @override
  Future<void> localStorage({
    required String token,
    required String userId,
    required DateTime expiryDate,
  }) async {
    final userData = json.encode({
      'token': token,
      'userId': userId,
      'expiryDate': expiryDate.toIso8601String(),
    });
    final prefAccess = await SharedPreferences.getInstance();
    prefAccess.setString("AuthData", userData);
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    final fb.FirebaseAuth _firebaseAuth = fb.FirebaseAuth.instance;
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }
}
