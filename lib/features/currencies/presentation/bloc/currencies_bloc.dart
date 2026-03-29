import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_supported_currencies.dart';
import 'currencies_event.dart';
import 'currencies_state.dart';

class CurrenciesBloc extends Bloc<CurrenciesEvent, CurrenciesState> {
  final GetSupportedCurrencies getSupportedCurrencies;

  CurrenciesBloc(this.getSupportedCurrencies) : super(CurrenciesInitial()) {
    on<LoadCurrencies>(_onLoadCurrencies);
  }

  Future<void> _onLoadCurrencies(
    LoadCurrencies event,
    Emitter<CurrenciesState> emit,
  ) async {
    emit(CurrenciesLoading());
    try {
      final currencies = await getSupportedCurrencies();
      emit(CurrenciesLoaded(currencies));
    } catch (_) {
      emit(const CurrenciesError(
        'Failed to load currencies. Please try again.',
      ));
    }
  }
}
