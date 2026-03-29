import 'package:equatable/equatable.dart';
import '../../domain/entities/historical_rate_entity.dart';

abstract class HistoryState extends Equatable {
  const HistoryState();

  @override
  List<Object> get props => [];
}

class HistoryInitial extends HistoryState {}

class HistoryLoading extends HistoryState {}

class HistoryLoaded extends HistoryState {
  final List<HistoricalRateEntity> rates;

  const HistoryLoaded(this.rates);

  @override
  List<Object> get props => [rates];
}

class HistoryError extends HistoryState {
  final String message;

  const HistoryError(this.message);

  @override
  List<Object> get props => [message];
}
