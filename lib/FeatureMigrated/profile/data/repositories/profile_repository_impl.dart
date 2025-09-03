import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../domain/entities/profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../models/profile_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final String token;
  final String userId;

  ProfileRepositoryImpl({required this.token, required this.userId});

  @override
  Future<Profile> getProfile(String id) async {
    print("getting prof");
    var uri = Uri.https(
      "brew-crew-88205-default-rtdb.firebaseio.com",
      "/userProfile/$id.json",
      {"auth": token},
    );
    try {
      http.Response response = await http.get(uri);
      print(response.statusCode);

      final profileJson = json.decode(response.body);

      return Profile(
        id: id,
        name: profileJson['displayName'],
        imageUrl: profileJson['ImageUrl'],
      );
      // return ProfileModel.fromJson(profileJson);

      print('jump');
    } catch (e) {
      print('could not get');
      print(e);
    }
    return ProfileModel(id: userId, name: 'User', imageUrl: '');
  }

  @override
  Future<Profile> loadProfile() async {
    var uri = Uri.https(
      "brew-crew-88205-default-rtdb.firebaseio.com",
      "/userProfile/$userId.json",
      {"auth": token},
    );
    try {
      http.Response response = await http.get(uri);
      // if (response.statusCode == 200 && response.body.isNotEmpty) {
      print(token);
      final profileJson = json.decode(response.body);
      return ProfileModel.fromJson(profileJson);
      //  }
    } catch (e) {
      print(e);
    }
    return ProfileModel(id: userId, name: 'User', imageUrl: '');
  }

  @override
  Future<void> updateProfile(Profile profile) async {
    var uri = Uri.https(
      "brew-crew-88205-default-rtdb.firebaseio.com",
      "/userProfile/${profile.id}.json",
      {"auth": token},
    );
    await http.put(uri, body: json.encode((profile as ProfileModel).toJson()));
  }
}
