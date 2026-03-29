import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/utils/currency_flag_mapper.dart';
import '../../domain/entities/currency_entity.dart';

class CurrencyTile extends StatelessWidget {
  final CurrencyEntity currency;

  const CurrencyTile({super.key, required this.currency});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SvgPicture.network(
        CurrencyFlagMapper.getFlagUrl(currency.code),
        width: 36,
        height: 24,
        fit: BoxFit.cover,
        placeholderBuilder: (_) => const SizedBox(
          width: 36,
          height: 24,
          child: Icon(Icons.flag_outlined, size: 20),
        ),
      ),
      title: Text(
        currency.code,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(currency.name),
    );
  }
}
