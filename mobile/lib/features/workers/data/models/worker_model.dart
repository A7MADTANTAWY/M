import 'package:equatable/equatable.dart';

class WorkerModel extends Equatable {
  final int id;
  final int? userId;
  final String? username;
  final String? phone;
  final String? address;
  final String? profileImage;
  final String? role;
  final int? categoryId;
  final String? categoryName;
  final String? categoryImage;
  final String description;
  final int experienceYears;
  final double averageRating;
  final int completedJobs;
  final bool isAvailable;
  final double score;
  final String? createdAt;

  const WorkerModel({
    required this.id,
    this.userId,
    this.username,
    this.phone,
    this.address,
    this.profileImage,
    this.role,
    this.categoryId,
    this.categoryName,
    this.categoryImage,
    this.description = '',
    this.experienceYears = 0,
    this.averageRating = 0.0,
    this.completedJobs = 0,
    this.isAvailable = true,
    this.score = 0.0,
    this.createdAt,
  });

  factory WorkerModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>?;
    final category = json['category'] as Map<String, dynamic>?;
    return WorkerModel(
      id: json['id'] as int,
      userId: user?['id'] as int?,
      username: user?['username'] as String?,
      phone: user?['phone'] as String?,
      address: user?['address'] as String?,
      profileImage: user?['profile_image'] as String?,
      role: user?['role'] as String?,
      categoryId: category?['id'] as int?,
      categoryName: category?['name'] as String?,
      categoryImage: category?['image'] as String?,
      description: json['description'] as String? ?? '',
      experienceYears: json['experience_years'] as int? ?? 0,
      averageRating: (json['average_rating'] as num?)?.toDouble() ?? 0.0,
      completedJobs: json['completed_jobs'] as int? ?? 0,
      isAvailable: json['is_available'] as bool? ?? true,
      score: (json['score'] as num?)?.toDouble() ?? 0.0,
      createdAt: json['created_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'description': description,
    'experience_years': experienceYears,
    'is_available': isAvailable,
  };

  @override
  List<Object?> get props => [
    id, userId, username, phone, address, profileImage, role,
    categoryId, categoryName, description, experienceYears,
    averageRating, completedJobs, isAvailable, score,
  ];
}
