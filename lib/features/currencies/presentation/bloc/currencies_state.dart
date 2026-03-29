import 'package:equatable/equatable.dart';
import '../../domain/entities/currency_entity.dart';

abstract class CurrenciesState extends Equatable {
  const CurrenciesState();

  @override
  List<Object> get props => [];
}

class CurrenciesInitial extends CurrenciesState {}

class CurrenciesLoading extends CurrenciesState {}

class CurrenciesLoaded extends CurrenciesState {
  final List<CurrencyEntity> currencies;

  const CurrenciesLoaded(this.currencies);

  @override
  List<Object> get props => [currencies];
}

class CurrenciesError extends CurrenciesState {
  final String message;

  const CurrenciesError(this.message);

  @override
  List<Object> get props => [message];
}
