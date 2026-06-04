import 'package:equatable/equatable.dart';
import 'package:mongez/features/auth/models/user.dart';

class ProfileModel extends Equatable {
  final int id;
  final String username;
  final String phone;
  final String address;
  final String? profileImage;
  final String role;
  final String? dateJoined;
  final int? workerId;
  final int? experienceYears;
  final double? averageRating;
  final int? completedJobs;
  final bool? isAvailable;
  final int? categoryId;
  final String? categoryName;

  const ProfileModel({
    required this.id,
    required this.username,
    required this.phone,
    this.address = '',
    this.profileImage,
    this.role = 'client',
    this.dateJoined,
    this.workerId,
    this.experienceYears,
    this.averageRating,
    this.completedJobs,
    this.isAvailable,
    this.categoryId,
    this.categoryName,
  });

  factory ProfileModel.fromUser(User user) {
    return ProfileModel(
      id: user.id ?? 0,
      username: user.username ?? '',
      phone: user.phone ?? '',
      address: user.address ?? '',
      profileImage: user.profileImage,
      role: user.role ?? 'client',
      dateJoined: user.dateJoined?.toIso8601String(),
    );
  }

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] as int,
      username: json['username'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      address: json['address'] as String? ?? '',
      profileImage: json['profile_image'] as String?,
      role: json['role'] as String? ?? 'client',
      dateJoined: json['date_joined'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'username': username,
    'phone': phone,
    'address': address,
  };

  ProfileModel copyWith({
    String? username,
    String? phone,
    String? address,
    String? profileImage,
    int? workerId,
    int? experienceYears,
    double? averageRating,
    int? completedJobs,
    bool? isAvailable,
    int? categoryId,
    String? categoryName,
  }) {
    return ProfileModel(
      id: id,
      username: username ?? this.username,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      profileImage: profileImage ?? this.profileImage,
      role: role,
      dateJoined: dateJoined,
      workerId: workerId ?? this.workerId,
      experienceYears: experienceYears ?? this.experienceYears,
      averageRating: averageRating ?? this.averageRating,
      completedJobs: completedJobs ?? this.completedJobs,
      isAvailable: isAvailable ?? this.isAvailable,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
    );
  }

  @override
  List<Object?> get props => [
    id, username, phone, address, profileImage, role,
    dateJoined, workerId, experienceYears, averageRating,
    completedJobs, isAvailable, categoryId, categoryName,
  ];
}
