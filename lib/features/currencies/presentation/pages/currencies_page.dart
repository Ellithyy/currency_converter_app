import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/di/injection.dart';
import '../bloc/currencies_bloc.dart';
import '../bloc/currencies_event.dart';
import '../bloc/currencies_state.dart';
import '../widgets/currency_tile.dart';

class CurrenciesPage extends StatelessWidget {
  const CurrenciesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CurrenciesBloc>()..add(const LoadCurrencies()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Currencies')),
        body: BlocBuilder<CurrenciesBloc, CurrenciesState>(
          builder: (context, state) {
            if (state is CurrenciesLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is CurrenciesError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline, size: 48, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(
                        state.message,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => context
                            .read<CurrenciesBloc>()
                            .add(const LoadCurrencies()),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (state is CurrenciesLoaded) {
              return ListView.separated(
                itemCount: state.currencies.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (_, index) =>
                    CurrencyTile(currency: state.currencies[index]),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
