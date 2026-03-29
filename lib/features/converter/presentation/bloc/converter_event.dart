import 'package:equatable/equatable.dart';

abstract class ConverterEvent extends Equatable {
  const ConverterEvent();

  @override
  List<Object> get props => [];
}

class ConvertRequested extends ConverterEvent {
  final String from;
  final String to;
  final double amount;

  const ConvertRequested({
    required this.from,
    required this.to,
    required this.amount,
  });

  @override
  List<Object> get props => [from, to, amount];
}
