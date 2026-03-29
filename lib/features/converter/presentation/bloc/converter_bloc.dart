import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/convert_currency.dart';
import 'converter_event.dart';
import 'converter_state.dart';

class ConverterBloc extends Bloc<ConverterEvent, ConverterState> {
  final ConvertCurrency convertCurrency;

  ConverterBloc(this.convertCurrency) : super(ConverterInitial()) {
    on<ConvertRequested>(_onConvertRequested);
  }

  Future<void> _onConvertRequested(
    ConvertRequested event,
    Emitter<ConverterState> emit,
  ) async {
    emit(ConverterLoading());
    try {
      final result = await convertCurrency(
        from: event.from,
        to: event.to,
        amount: event.amount,
      );
      emit(ConverterLoaded(result));
    } catch (_) {
      emit(const ConverterError(
        'Conversion failed. Please check your connection and try again.',
      ));
    }
  }
}
