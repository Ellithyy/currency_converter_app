import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/di/injection.dart';
import '../../../currencies/presentation/bloc/currencies_bloc.dart';
import '../../../currencies/presentation/bloc/currencies_event.dart';
import '../../../currencies/presentation/bloc/currencies_state.dart';
import '../bloc/converter_bloc.dart';
import '../bloc/converter_event.dart';
import '../bloc/converter_state.dart';
import '../widgets/amount_input.dart';
import '../widgets/conversion_result_card.dart';
import '../widgets/currency_selector.dart';

class ConverterPage extends StatelessWidget {
  const ConverterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<CurrenciesBloc>()..add(const LoadCurrencies()),
        ),
        BlocProvider(create: (_) => sl<ConverterBloc>()),
      ],
      child: const _ConverterView(),
    );
  }
}

class _ConverterView extends StatefulWidget {
  const _ConverterView();

  @override
  State<_ConverterView> createState() => _ConverterViewState();
}

class _ConverterViewState extends State<_ConverterView> {
  final _amountController = TextEditingController();
  String? _from = 'USD';
  String? _to = 'EUR';

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _onConvert() {
    final amount = double.tryParse(_amountController.text.trim());
    if (amount == null || _from == null || _to == null) return;
    context.read<ConverterBloc>().add(
          ConvertRequested(from: _from!, to: _to!, amount: amount),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Converter')),
      body: BlocBuilder<CurrenciesBloc, CurrenciesState>(
        builder: (context, currState) {
          final currencies = currState is CurrenciesLoaded
              ? currState.currencies.map((c) => c.code).toList()
              : <String>['USD', 'EUR', 'GBP', 'JPY', 'CAD', 'AUD', 'CHF'];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AmountInput(controller: _amountController),
                const SizedBox(height: 16),
                CurrencySelector(
                  label: 'From',
                  value: _from,
                  currencies: currencies,
                  onChanged: (v) => setState(() => _from = v),
                ),
                const SizedBox(height: 16),
                CurrencySelector(
                  label: 'To',
                  value: _to,
                  currencies: currencies,
                  onChanged: (v) => setState(() => _to = v),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _onConvert,
                  child: const Text('Convert'),
                ),
                const SizedBox(height: 24),
                BlocBuilder<ConverterBloc, ConverterState>(
                  builder: (context, state) {
                    if (state is ConverterLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is ConverterError) {
                      return Center(
                        child: Text(
                          state.message,
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    }
                    if (state is ConverterLoaded) {
                      return ConversionResultCard(result: state.result);
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
