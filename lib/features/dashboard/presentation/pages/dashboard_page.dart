// lib/features/dashboard/presentation/pages/dashboard_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/event_summary_entity.dart';
import '../bloc/dashboard_bloc.dart';
import 'event_detail_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<DashboardBloc>()..add(const DashboardLoadSummaries()),
      child: const _DashboardView(),
    );
  }
}

class _DashboardView extends StatelessWidget {
  const _DashboardView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => context
                .read<DashboardBloc>()
                .add(const DashboardLoadSummaries()),
          ),
        ],
      ),
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoading || state is DashboardInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is DashboardFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline,
                      size: 48, color: Theme.of(context).colorScheme.error),
                  const SizedBox(height: 12),
                  Text(state.message, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context
                        .read<DashboardBloc>()
                        .add(const DashboardLoadSummaries()),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is DashboardSummariesLoaded) {
            return RefreshIndicator(
              onRefresh: () async => context
                  .read<DashboardBloc>()
                  .add(const DashboardLoadSummaries()),
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // ── Grand Total Summary Cards ──────────
                  Text(
                    'Overall Summary',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _SummaryCard(
                          label: 'Total Incurred',
                          amount: state.grandTotalIncurred,
                          color: Colors.blue,
                          icon: Icons.account_balance_wallet_rounded,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _SummaryCard(
                          label: 'Total Paid',
                          amount: state.grandTotalPaid,
                          color: Colors.green,
                          icon: Icons.check_circle_rounded,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _SummaryCard(
                          label: 'Outstanding',
                          amount: state.grandTotalOutstanding,
                          color: Colors.red,
                          icon: Icons.pending_rounded,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // ── Event Table Header ─────────────────
                  Text(
                    'By Event',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  if (state.summaries.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 32),
                        child: Column(
                          children: [
                            Icon(
                              Icons.bar_chart_rounded,
                              size: 64,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.3),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                                'No data yet. Submit expenses to see dashboard.'),
                          ],
                        ),
                      ),
                    )
                  else
                    // ── Event Table ──────────────────────
                    Card(
                      child: Column(
                        children: [
                          // Table header
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 10),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withValues(alpha: 0.1),
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(12)),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Text('Event',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold)),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text('Incurred',
                                      textAlign: TextAlign.right,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold)),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text('Paid',
                                      textAlign: TextAlign.right,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold)),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text('Outstanding',
                                      textAlign: TextAlign.right,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ),

                          // Table rows
                          ...state.summaries.asMap().entries.map((entry) {
                            final index = entry.key;
                            final summary = entry.value;
                            final isLast = index == state.summaries.length - 1;

                            return _EventRow(
                              summary: summary,
                              isLast: isLast,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => EventDetailPage(
                                      eventId: summary.eventId,
                                      eventName: summary.eventName,
                                    ),
                                  ),
                                );
                              },
                            );
                          }),
                        ],
                      ),
                    ),

                  const SizedBox(height: 24),
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

// ── Summary Card ──────────────────────────────────────────────
class _SummaryCard extends StatelessWidget {
  final String label;
  final double amount;
  final Color color;
  final IconData icon;

  const _SummaryCard({
    required this.label,
    required this.amount,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat.currency(locale: 'en_IN', symbol: '₹');
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 6),
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
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.6),
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// ── Event Table Row ───────────────────────────────────────────
class _EventRow extends StatelessWidget {
  final EventSummaryEntity summary;
  final bool isLast;
  final VoidCallback onTap;

  const _EventRow({
    required this.summary,
    required this.isLast,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat.currency(locale: 'en_IN', symbol: '₹');

    // Outstanding color
    final outstandingColor = summary.isFullyPaid
        ? Colors.green
        : summary.isPartiallyPaid
            ? Colors.orange
            : Colors.red;

    return InkWell(
      onTap: onTap,
      borderRadius: isLast
          ? const BorderRadius.vertical(bottom: Radius.circular(12))
          : BorderRadius.zero,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          border: isLast
              ? null
              : Border(
                  bottom: BorderSide(
                    color: Theme.of(context)
                        .colorScheme
                        .outline
                        .withValues(alpha: 0.2),
                  ),
                ),
        ),
        child: Row(
          children: [
            // Event name + tap indicator
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      summary.eventName,
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 13),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 16,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.4),
                  ),
                ],
              ),
            ),
            // Total Incurred
            Expanded(
              flex: 2,
              child: Text(
                fmt.format(summary.totalIncurred),
                textAlign: TextAlign.right,
                style: const TextStyle(fontSize: 12),
              ),
            ),
            // Total Paid
            Expanded(
              flex: 2,
              child: Text(
                fmt.format(summary.totalPaid),
                textAlign: TextAlign.right,
                style: const TextStyle(fontSize: 12, color: Colors.green),
              ),
            ),
            // Outstanding
            Expanded(
              flex: 2,
              child: Text(
                fmt.format(summary.outstanding),
                textAlign: TextAlign.right,
                style: TextStyle(
                    fontSize: 12,
                    color: outstandingColor,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
