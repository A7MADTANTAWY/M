import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mongez/features/orders/data/models/order_model.dart';
import 'package:mongez/features/orders/presentation/cubit/customer_orders_cubit.dart';
import 'package:mongez/features/orders/presentation/cubit/technician_orders_cubit.dart';
import 'package:mongez/features/orders/presentation/screens/rate_order_screen.dart';
import 'package:mongez/features/orders/presentation/widgets/status_badge.dart';
import 'package:mongez/generated/l10n.dart';
import 'package:mongez/widgets/custom_app_bar.dart';

class OrderDetailsScreen extends StatefulWidget {
  final OrderModel order;
  final bool isCustomer;

  const OrderDetailsScreen({
    super.key,
    required this.order,
    required this.isCustomer,
  });

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  late OrderModel _order;

  @override
  void initState() {
    super.initState();
    _order = widget.order;
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return '';
    try {
      final dt = DateTime.parse(dateStr);
      return "${dt.day}/${dt.month}/${dt.year}";
    } catch (_) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: CustomAppBar(title: lang.requestDetails),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          _order.categoryName ?? 'Order #${_order.id}',
                          style: textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      StatusBadge(status: _order.status, isCustomer: widget.isCustomer),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _order.description,
                    style: textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  _infoRow(Icons.person, widget.isCustomer
                      ? '${lang.serviceProvider}: ${_order.workerName ?? ""}'
                      : '${lang.customer}: ${_order.clientName ?? ""}'),
                  if (_order.clientPhone != null || _order.workerPhone != null)
                    _infoRow(Icons.phone, _order.clientPhone ?? _order.workerPhone ?? ''),
                  if (_order.address.isNotEmpty)
                    _infoRow(Icons.location_on, _order.address),
                  if (_order.phone.isNotEmpty)
                    _infoRow(Icons.phone, 'Phone: ${_order.phone}'),
                  _infoRow(Icons.calendar_today, _formatDate(_order.createdAt)),
                  const SizedBox(height: 16),
                  _buildDetailsActions(context),
                ],
              ),
            ),
            if (widget.isCustomer && _order.status == OrderStatus.waitingConfirmation) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.purple.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.check_circle, color: Colors.purple, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            S.of(context).workerMarkedFinished,
                            style: TextStyle(color: Colors.purple.shade700),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 44,
                      child: ElevatedButton(
                        onPressed: () => _doConfirmCompletion(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(S.of(context).confirmCompletion),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            if (widget.isCustomer && _order.status == OrderStatus.completed) ...[
              const SizedBox(height: 16),
              if (_order.isRated)
                _buildRatedBanner(context)
              else
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: () => _navigateToRateOrder(context),
                    icon: const Icon(Icons.star_half),
                    label: Text(S.of(context).rateOrder),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  Widget _buildDetailsActions(BuildContext context) {
    final lang = S.of(context);
    final theme = Theme.of(context);

    if (widget.isCustomer) {
      if (_order.status == OrderStatus.pending) {
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => _showCancelDialog(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.error,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Text(lang.cancel),
          ),
        );
      }
      if (_order.status == OrderStatus.accepted) {
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.green.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.green),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${_order.workerName ?? lang.serviceProvider} accepted your request',
                  style: TextStyle(color: Colors.green.shade700),
                ),
              ),
            ],
          ),
        );
      }
      if (_order.status == OrderStatus.waitingConfirmation) {
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.purple.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.purple),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  lang.workerMarkedFinished,
                  style: TextStyle(color: Colors.purple.shade700),
                ),
              ),
            ],
          ),
        );
      }
      if (_order.status == OrderStatus.completed) {
        return Row(
          children: [
            Icon(Icons.check_circle, size: 16, color: Colors.green),
            const SizedBox(width: 6),
            Text(lang.completed, style: TextStyle(color: Colors.green.shade700, fontSize: 13)),
          ],
        );
      }
      if (_order.status == OrderStatus.rejected) {
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.red.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(Icons.cancel, color: Colors.red),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  lang.rejectedByWorker,
                  style: TextStyle(color: Colors.red.shade700),
                ),
              ),
            ],
          ),
        );
      }
      if (_order.status == OrderStatus.cancelled) {
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(Icons.cancel, color: Colors.grey),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  lang.cancelledByYou,
                  style: TextStyle(color: Colors.grey.shade700),
                ),
              ),
            ],
          ),
        );
      }
    } else {
      if (_order.status == OrderStatus.pending) {
        return Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  context.read<TechnicianOrdersCubit>().acceptOrder(_order.id);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(lang.accept),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  context.read<TechnicianOrdersCubit>().rejectOrder(_order.id);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.error,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(lang.cancel),
              ),
            ),
          ],
        );
      }
      if (_order.status == OrderStatus.accepted) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.build, color: Colors.blue),
                  const SizedBox(width: 8),
                  Text(
                    'Service is in progress',
                    style: TextStyle(color: Colors.blue.shade700),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context.read<TechnicianOrdersCubit>().markAsFinished(_order.id);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(lang.markAsFinished),
              ),
            ),
          ],
        );
      }
      if (_order.status == OrderStatus.waitingConfirmation) {
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.purple.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(Icons.hourglass_top, color: Colors.purple),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  lang.waitingConfirmation,
                  style: TextStyle(color: Colors.purple.shade700),
                ),
              ),
            ],
          ),
        );
      }
    }

    return const SizedBox();
  }

  void _showCancelDialog(BuildContext context) {
    final lang = S.of(context);
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(lang.cancelRequest),
        content: Text(lang.cancelRequestConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(lang.no),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<CustomerOrdersCubit>().cancelOrder(_order.id);
              Navigator.pop(context);
            },
            child: Text(lang.yes, style: TextStyle(color: theme.colorScheme.error)),
          ),
        ],
      ),
    );
  }

  Widget _buildRatedBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              S.of(context).ratingSubmitted,
              style: TextStyle(color: Colors.green.shade700),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _doConfirmCompletion(BuildContext context) async {
    await context.read<CustomerOrdersCubit>().confirmCompletion(_order.id);
    if (mounted) {
      setState(() => _order = _order.copyWith(status: OrderStatus.completed));
    }
  }

  Future<void> _navigateToRateOrder(BuildContext context) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => RateOrderScreen(order: _order),
      ),
    );
    if (result == true && mounted) {
      setState(() => _order = _order.copyWith(isRated: true));
      context.read<CustomerOrdersCubit>().getOrders();
    }
  }
}
