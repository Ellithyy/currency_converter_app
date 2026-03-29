import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_historical_rates.dart';
import 'history_event.dart';
import 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final GetHistoricalRates getHistoricalRates;

  HistoryBloc(this.getHistoricalRates) : super(HistoryInitial()) {
    on<LoadHistoricalRates>(_onLoad);
  }

  Future<void> _onLoad(
    LoadHistoricalRates event,
    Emitter<HistoryState> emit,
  ) async {
    emit(HistoryLoading());
    try {
      final rates = await getHistoricalRates();
      emit(HistoryLoaded(rates));
    } catch (_) {
      emit(const HistoryError(
        'Failed to load historical rates. Please try again.',
      ));
    }
  }
}
