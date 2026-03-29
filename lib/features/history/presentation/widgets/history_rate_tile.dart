import 'package:flutter/material.dart';
import '../../domain/entities/historical_rate_entity.dart';

class HistoryRateTile extends StatelessWidget {
  final HistoricalRateEntity rate;

  const HistoryRateTile({super.key, required this.rate});

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(
        _formatDate(rate.date),
        style: const TextStyle(fontSize: 13, color: Colors.grey),
      ),
      title: Text(
        '${rate.fromCurrency} → ${rate.toCurrency}',
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      trailing: Text(
        rate.rate.toStringAsFixed(4),
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
      ),
    );
  }
}
