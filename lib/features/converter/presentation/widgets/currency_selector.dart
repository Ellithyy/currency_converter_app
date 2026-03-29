import 'package:flutter/material.dart';

class CurrencySelector extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> currencies;
  final ValueChanged<String?> onChanged;

  const CurrencySelector({
    super.key,
    required this.label,
    required this.value,
    required this.currencies,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final safeValue = currencies.contains(value) ? value : null;

    return DropdownButtonFormField<String>(
      value: safeValue,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      items: currencies
          .map((code) => DropdownMenuItem(value: code, child: Text(code)))
          .toList(),
      onChanged: onChanged,
    );
  }
}
