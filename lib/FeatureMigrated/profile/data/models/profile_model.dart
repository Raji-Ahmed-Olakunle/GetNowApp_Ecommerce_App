import '../../domain/entities/profile.dart';

class ProfileModel extends Profile {
  final String? id;
  final String? name;

  final String? imageUrl;

  ProfileModel({this.id, this.name, this.imageUrl})
    : super(id: id, name: name, imageUrl: imageUrl);

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
    id: json['id'],
    name: json['name'],

    imageUrl: json['imageUrl'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,

    'imageUrl': imageUrl,
  };
}
