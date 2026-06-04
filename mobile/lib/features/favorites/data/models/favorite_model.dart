import 'package:equatable/equatable.dart';
import 'package:mongez/features/workers/data/models/worker_model.dart';

class FavoriteModel extends Equatable {
  final int id;
  final int? workerId;
  final WorkerModel? workerInfo;
  final String? createdAt;

  const FavoriteModel({
    required this.id,
    this.workerId,
    this.workerInfo,
    this.createdAt,
  });

  factory FavoriteModel.fromJson(Map<String, dynamic> json) {
    final workerInfo = json['worker_info'] as Map<String, dynamic>?;
    return FavoriteModel(
      id: json['id'] as int,
      workerId: json['worker_id'] as int?,
      workerInfo: workerInfo != null ? WorkerModel.fromJson(workerInfo) : null,
      createdAt: json['created_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'worker_id': workerId,
  };

  @override
  List<Object?> get props => [id, workerId, workerInfo, createdAt];
}
