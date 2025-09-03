import '../../domain/entities/category.dart';

class CategoryModel extends Category {
  CategoryModel({
    required String id,
    required String title,
    required String imageUrl,
  }) : super(
          id: id,
          title: title,
          imageUrl: imageUrl,
        );

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        id: json['id'],
        title: json['title'],
        imageUrl: json['imageUrl'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'imageUrl': imageUrl,
      };
} 