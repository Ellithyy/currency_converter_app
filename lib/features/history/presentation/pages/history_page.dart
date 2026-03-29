import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/di/injection.dart';
import '../../domain/entities/historical_rate_entity.dart';
import '../bloc/history_bloc.dart';
import '../bloc/history_event.dart';
import '../bloc/history_state.dart';
import '../widgets/history_rate_tile.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<HistoryBloc>()..add(const LoadHistoricalRates()),
      child: Scaffold(
        appBar: AppBar(title: const Text('History')),
        body: BlocBuilder<HistoryBloc, HistoryState>(
          builder: (context, state) {
            if (state is HistoryLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is HistoryError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline,
                          size: 48, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(state.message, textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => context
                            .read<HistoryBloc>()
                            .add(const LoadHistoricalRates()),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (state is HistoryLoaded) {
              return _HistoryList(rates: state.rates);
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _HistoryList extends StatelessWidget {
  final List<HistoricalRateEntity> rates;

  const _HistoryList({required this.rates});

  @override
  Widget build(BuildContext context) {
    final eurRates = rates
        .where((r) => r.toCurrency == 'EUR')
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));

    final gbpRates = rates
        .where((r) => r.toCurrency == 'GBP')
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));

    return ListView(
      children: [
        _SectionHeader(title: 'USD → EUR'),
        ...eurRates.map((r) => HistoryRateTile(rate: r)),
        const Divider(height: 32, thickness: 1),
        _SectionHeader(title: 'USD → GBP'),
        ...gbpRates.map((r) => HistoryRateTile(rate: r)),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
    );
  }
}
