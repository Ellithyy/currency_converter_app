import 'package:flutter/material.dart';
import '../../domain/entities/conversion_result_entity.dart';

class ConversionResultCard extends StatelessWidget {
  final ConversionResultEntity result;

  const ConversionResultCard({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${result.amount} ${result.fromCurrency}  =',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              '${result.convertedAmount.toStringAsFixed(4)} ${result.toCurrency}',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '1 ${result.fromCurrency} = ${result.rate.toStringAsFixed(6)} ${result.toCurrency}',
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
