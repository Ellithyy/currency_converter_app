import 'package:equatable/equatable.dart';
import '../../domain/entities/conversion_result_entity.dart';

abstract class ConverterState extends Equatable {
  const ConverterState();

  @override
  List<Object> get props => [];
}

class ConverterInitial extends ConverterState {}

class ConverterLoading extends ConverterState {}

class ConverterLoaded extends ConverterState {
  final ConversionResultEntity result;

  const ConverterLoaded(this.result);

  @override
  List<Object> get props => [result];
}

class ConverterError extends ConverterState {
  final String message;

  const ConverterError(this.message);

  @override
  List<Object> get props => [message];
}
