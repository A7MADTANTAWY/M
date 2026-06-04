import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int? id;
  final String? username;
  final String? phone;
  final String? address;
  final String? profileImage;
  final String? role;
  final DateTime? dateJoined;

  const User({
    this.id,
    this.username,
    this.phone,
    this.address,
    this.profileImage,
    this.role,
    this.dateJoined,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'] as int?,
    username: json['username'] as String?,
    phone: json['phone'] as String?,
    address: json['address'] as String?,
    profileImage: json['profile_image'] as String?,
    role: json['role'] as String?,
    dateJoined: json['date_joined'] == null
        ? null
        : DateTime.parse(json['date_joined'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'phone': phone,
    'address': address,
    'profile_image': profileImage,
    'role': role,
    'date_joined': dateJoined?.toIso8601String(),
  };

  @override
  List<Object?> get props {
    return [id, username, phone, address, profileImage, role, dateJoined];
  }
}
