import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:mongez/core/constants/endpoints.dart';
import 'package:mongez/errors/failure.dart';
import 'package:mongez/features/orders/data/models/order_model.dart';
import 'package:mongez/features/orders/domain/order_repository.dart';
import 'package:mongez/services/api_service.dart';

class OrderRepositoryImpl implements OrderRepository {
  final ApiService apiService;

  OrderRepositoryImpl(this.apiService);

  @override
  Future<Either<Failure, List<OrderModel>>> getOrders() async {
    try {
      final data = await apiService.get(endPoint: Endpoints.orders);
      final list = data as List<dynamic>? ?? [];
      final orders = list.map((e) => OrderModel.fromJson(e)).toList();
      return right(orders);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioException(e));
      }
      return left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, OrderModel>> getOrderById(int id) async {
    try {
      final data = await apiService.get(endPoint: Endpoints.orderById(id));
      return right(OrderModel.fromJson(data));
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioException(e));
      }
      return left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, OrderModel>> createOrder({
    required int serviceCategory,
    required int workerId,
    required String description,
    String? address,
    String? phone,
  }) async {
    try {
      final body = <String, dynamic>{
        'service_category': serviceCategory,
        'worker_id': workerId,
        'description': description,
      };
      if (address != null) body['address'] = address;
      if (phone != null) body['phone'] = phone;

      final data = await apiService.post(endPoint: Endpoints.orders, body: body);
      return right(OrderModel.fromJson(data));
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioException(e));
      }
      return left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, OrderModel>> acceptOrder(int id) async {
    try {
      final data = await apiService.post(endPoint: Endpoints.orderAccept(id));
      return right(OrderModel.fromJson(data));
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioException(e));
      }
      return left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, OrderModel>> rejectOrder(int id) async {
    try {
      final data = await apiService.post(endPoint: Endpoints.orderReject(id));
      return right(OrderModel.fromJson(data));
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioException(e));
      }
      return left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> cancelOrder(int id) async {
    try {
      await apiService.post(endPoint: Endpoints.orderCancel(id));
      return right(null);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioException(e));
      }
      return left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, OrderModel>> markAsFinished(int id) async {
    try {
      final data = await apiService.post(endPoint: Endpoints.orderMarkFinished(id));
      return right(OrderModel.fromJson(data));
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioException(e));
      }
      return left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, OrderModel>> confirmCompletion(int id) async {
    try {
      final data = await apiService.post(endPoint: Endpoints.orderConfirmCompletion(id));
      return right(OrderModel.fromJson(data));
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioException(e));
      }
      return left(ServerFailure(errorMessage: e.toString()));
    }
  }
}
