// lib/features/dashboard/presentation/pages/event_detail_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/expense_detail_entity.dart';
import '../bloc/dashboard_bloc.dart';

class EventDetailPage extends StatelessWidget {
  final String eventId;
  final String eventName;

  const EventDetailPage({
    super.key,
    required this.eventId,
    required this.eventName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<DashboardBloc>()
        ..add(DashboardLoadDetails(
          eventId: eventId,
          eventName: eventName,
        )),
      child: _EventDetailView(eventName: eventName),
    );
  }
}

class _EventDetailView extends StatelessWidget {
  final String eventName;
  const _EventDetailView({required this.eventName});

  @override
  Widget build(BuildContext context) {
    final fmt =
        NumberFormat.currency(locale: 'en_IN', symbol: '₹');

    return Scaffold(
      appBar: AppBar(
        title: Text(eventName),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () {
              final state = context.read<DashboardBloc>().state;
              if (state is DashboardDetailsLoaded) {
                context.read<DashboardBloc>().add(
                      DashboardLoadDetails(
                        eventId:   state.eventId,
                        eventName: state.eventName,
                      ),
                    );
              }
            },
          ),
        ],
      ),
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoading ||
              state is DashboardInitial) {
            return const Center(
                child: CircularProgressIndicator());
          }

          if (state is DashboardFailure) {
            return Center(child: Text(state.message));
          }

          if (state is DashboardDetailsLoaded) {
            return RefreshIndicator(
              onRefresh: () async =>
                  context.read<DashboardBloc>().add(
                        DashboardLoadDetails(
                          eventId:   state.eventId,
                          eventName: state.eventName,
                        ),
                      ),
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // ── Event Summary Cards ────────────────
                  Text(
                    'Event Summary',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(
                            fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _MiniCard(
                          label: 'Incurred',
                          amount:
                              state.eventTotalIncurred,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _MiniCard(
                          label: 'Paid',
                          amount: state.eventTotalPaid,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _MiniCard(
                          label: 'Outstanding',
                          amount:
                              state.eventTotalOutstanding,
                          color:
                              state.eventTotalOutstanding <=
                                      0
                                  ? Colors.green
                                  : Colors.red,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // ── Detail Header ──────────────────────
                  Text(
                    'Expense Breakdown',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(
                            fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  if (state.details.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 32),
                        child:
                            Text('No expense details found.'),
                      ),
                    )
                  else
                    // ── Detail Cards ───────────────────
                    ...state.details.map(
                      (detail) => _DetailCard(
                          detail: detail, fmt: fmt),
                    ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

// ── Mini Summary Card ─────────────────────────────────────────
class _MiniCard extends StatelessWidget {
  final String label;
  final double amount;
  final Color color;

  const _MiniCard({
    required this.label,
    required this.amount,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final fmt =
        NumberFormat.currency(locale: 'en_IN', symbol: '₹');
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
            color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            fmt.format(amount),
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: Theme.of(context)
                .textTheme
                .labelSmall
                ?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.6),
                ),
          ),
        ],
      ),
    );
  }
}

// ── Detail Card (one per expense request) ────────────────────
class _DetailCard extends StatelessWidget {
  final ExpenseDetailEntity detail;
  final NumberFormat fmt;

  const _DetailCard({
    required this.detail,
    required this.fmt,
  });

  Color get _statusColor {
    if (detail.isFullyPaid) return Colors.green;
    if (detail.isPartiallyPaid) return Colors.orange;
    return Colors.red;
  }

  String get _statusLabel {
    if (detail.isFullyPaid) return 'Paid';
    if (detail.isPartiallyPaid) return 'Partial';
    return 'Unpaid';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              children: [
                Expanded(
                  child: Text(
                    detail.expenseType,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: _statusColor
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: _statusColor
                            .withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    _statusLabel,
                    style: TextStyle(
                      color: _statusColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),
            const Divider(height: 1),
            const SizedBox(height: 8),

            // Details grid
            _Row('Vendor',    detail.vendorName),
            _Row('Raised By', detail.raisedBy),
            _Row('Total',     fmt.format(detail.totalAmount)),
            _Row('Paid',      fmt.format(detail.totalPaid)),
            _Row(
              'Outstanding',
              fmt.format(detail.outstanding),
              valueColor: _statusColor,
            ),
            if (detail.lastPaymentMode != null)
              _Row('Payment Mode',
                  detail.lastPaymentMode!
                      .replaceAll('_', ' ')),
            if (detail.description != null)
              _Row('Description', detail.description!),
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _Row(this.label, this.value, {this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.6),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: valueColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}