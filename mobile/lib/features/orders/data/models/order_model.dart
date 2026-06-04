import 'package:equatable/equatable.dart';

enum OrderStatus {
  pending,
  accepted,
  inProgress,
  waitingConfirmation,
  rejected,
  cancelled,
  completed;

  String get apiValue => name;
  static OrderStatus fromApi(String value) {
    switch (value.toUpperCase()) {
      case 'PENDING': return OrderStatus.pending;
      case 'ACCEPTED': return OrderStatus.accepted;
      case 'IN_PROGRESS': return OrderStatus.inProgress;
      case 'WAITING_CONFIRMATION': return OrderStatus.waitingConfirmation;
      case 'REJECTED': return OrderStatus.rejected;
      case 'CANCELLED': return OrderStatus.cancelled;
      case 'COMPLETED': return OrderStatus.completed;
      default: return OrderStatus.pending;
    }
  }
}

class OrderModel extends Equatable {
  final int id;
  final int? clientId;
  final String? clientName;
  final String? clientPhone;
  final String? clientImage;
  final int? workerId;
  final String? workerName;
  final String? workerPhone;
  final String? workerImage;
  final int? categoryId;
  final String? categoryName;
  final String? categoryImage;
  final String description;
  final String address;
  final String phone;
  final OrderStatus status;
  final bool isRated;
  final String? createdAt;
  final String? acceptedAt;
  final String? startedAt;
  final String? completedAt;
  final String? rejectedAt;
  final String? cancelledAt;

  const OrderModel({
    required this.id,
    this.clientId,
    this.clientName,
    this.clientPhone,
    this.clientImage,
    this.workerId,
    this.workerName,
    this.workerPhone,
    this.workerImage,
    this.categoryId,
    this.categoryName,
    this.categoryImage,
    this.description = '',
    this.address = '',
    this.phone = '',
    this.status = OrderStatus.pending,
    this.isRated = false,
    this.createdAt,
    this.acceptedAt,
    this.startedAt,
    this.completedAt,
    this.rejectedAt,
    this.cancelledAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final client = json['client'] as Map<String, dynamic>?;
    final worker = json['worker'] as Map<String, dynamic>?;
    final category = json['service_category'] as Map<String, dynamic>?;
    return OrderModel(
      id: json['id'] as int,
      clientId: client?['id'] as int?,
      clientName: client?['username'] as String?,
      clientPhone: client?['phone'] as String?,
      clientImage: client?['profile_image'] as String?,
      workerId: worker?['id'] as int?,
      workerName: worker?['username'] as String?,
      workerPhone: worker?['phone'] as String?,
      workerImage: worker?['profile_image'] as String?,
      categoryId: category?['id'] as int?,
      categoryName: category?['name'] as String?,
      categoryImage: category?['image'] as String?,
      description: json['description'] as String? ?? '',
      address: json['address'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      status: OrderStatus.fromApi(json['status'] as String? ?? 'PENDING'),
      isRated: json['is_rated'] as bool? ?? false,
      createdAt: json['created_at'] as String?,
      acceptedAt: json['accepted_at'] as String?,
      startedAt: json['started_at'] as String?,
      completedAt: json['completed_at'] as String?,
      rejectedAt: json['rejected_at'] as String?,
      cancelledAt: json['cancelled_at'] as String?,
    );
  }

  OrderModel copyWith({bool? isRated, OrderStatus? status}) {
    return OrderModel(
      id: id,
      clientId: clientId,
      clientName: clientName,
      clientPhone: clientPhone,
      clientImage: clientImage,
      workerId: workerId,
      workerName: workerName,
      workerPhone: workerPhone,
      workerImage: workerImage,
      categoryId: categoryId,
      categoryName: categoryName,
      categoryImage: categoryImage,
      description: description,
      address: address,
      phone: phone,
      status: status ?? this.status,
      isRated: isRated ?? this.isRated,
      createdAt: createdAt,
      acceptedAt: acceptedAt,
      startedAt: startedAt,
      completedAt: completedAt,
      rejectedAt: rejectedAt,
      cancelledAt: cancelledAt,
    );
  }

  @override
  List<Object?> get props => [
    id, clientId, workerId, categoryId, description,
    address, phone, status, isRated, createdAt,
  ];
}
