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
  bool _amountTouched = false;

  @override
  void initState() {
    super.initState();
    _amountController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  String? get _amountError {
    if (!_amountTouched) return null;
    final text = _amountController.text.trim();
    if (text.isEmpty) return 'Please enter an amount';
    final amount = double.tryParse(text);
    if (amount == null) return 'Please enter a valid number';
    if (amount <= 0) return 'Amount must be greater than zero';
    return null;
  }

  bool get _canConvert {
    final text = _amountController.text.trim();
    if (text.isEmpty) return false;
    final amount = double.tryParse(text);
    if (amount == null || amount <= 0) return false;
    if (_from == null || _to == null) return false;
    if (_from == _to) return false;
    return true;
  }

  void _onConvert() {
    setState(() => _amountTouched = true);
    if (!_canConvert) return;
    context.read<ConverterBloc>().add(
          ConvertRequested(
            from: _from!,
            to: _to!,
            amount: double.parse(_amountController.text.trim()),
          ),
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

          final sameCurrency = _from != null && _from == _to;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AmountInput(
                  controller: _amountController,
                  errorText: _amountError,
                ),
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
                if (sameCurrency) ...[
                  const SizedBox(height: 8),
                  const Text(
                    'Source and target currency must be different.',
                    style: TextStyle(color: Colors.orange, fontSize: 13),
                  ),
                ],
                const SizedBox(height: 24),
                BlocBuilder<ConverterBloc, ConverterState>(
                  builder: (context, state) {
                    final isLoading = state is ConverterLoading;
                    return ElevatedButton(
                      onPressed: isLoading ? null : _onConvert,
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Convert'),
                    );
                  },
                ),
                const SizedBox(height: 24),
                BlocBuilder<ConverterBloc, ConverterState>(
                  builder: (context, state) {
                    if (state is ConverterError) {
                      return Center(
                        child: Text(
                          state.message,
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
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
