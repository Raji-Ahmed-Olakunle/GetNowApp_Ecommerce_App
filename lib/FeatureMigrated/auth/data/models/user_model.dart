import '../../domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required String id,
    required String email,
    required String token,
    DateTime? expiryDate,
  }) : super(id: id, email: email, token: token, expiryDate: expiryDate);

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'],
        email: json['email'],
        token: json['token'],
        expiryDate: json['expiryDate'] != null ? DateTime.parse(json['expiryDate']) : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'token': token,
        if (expiryDate != null) 'expiryDate': expiryDate!.toIso8601String(),
      };
} 