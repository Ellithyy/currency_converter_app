import 'package:equatable/equatable.dart';

class ConversionResultEntity extends Equatable {
  final String fromCurrency;
  final String toCurrency;
  final double amount;
  final double convertedAmount;
  final double rate;

  const ConversionResultEntity({
    required this.fromCurrency,
    required this.toCurrency,
    required this.amount,
    required this.convertedAmount,
    required this.rate,
  });

  @override
  List<Object> get props => [
        fromCurrency,
        toCurrency,
        amount,
        convertedAmount,
        rate,
      ];
}
