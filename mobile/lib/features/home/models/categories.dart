import 'package:equatable/equatable.dart';

import 'package:mongez/core/constants/api_constants.dart';

class CategoriesModel extends Equatable {
  final int? id;
  final String? name;
  final String? image;

  const CategoriesModel({this.id, this.name, this.image});

  factory CategoriesModel.fromJson(Map<String, dynamic> json) =>
      CategoriesModel(
        id: json['id'] as int?,
        name: json['name'] as String?,
        image: json['image'] as String?,
      );

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'image': image};

  String? get imageUrl =>
      image != null && image!.isNotEmpty ? '${ApiConstants.baseUrl}$image' : null;

  @override
  List<Object?> get props => [id, name, image];
}
