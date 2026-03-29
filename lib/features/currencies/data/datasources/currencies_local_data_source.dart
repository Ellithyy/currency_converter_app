import 'package:sqflite/sqflite.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/database/database_tables.dart';
import '../models/currency_model.dart';

abstract class CurrenciesLocalDataSource {
  Future<bool> hasCurrencies();
  Future<List<CurrencyModel>> getCachedCurrencies();
  Future<void> cacheCurrencies(List<CurrencyModel> currencies);
}

class CurrenciesLocalDataSourceImpl implements CurrenciesLocalDataSource {
  final AppDatabase appDatabase;

  CurrenciesLocalDataSourceImpl(this.appDatabase);

  @override
  Future<bool> hasCurrencies() async {
    final db = await appDatabase.database;
    final result = await db.query(DatabaseTables.currencies, limit: 1);
    return result.isNotEmpty;
  }

  @override
  Future<List<CurrencyModel>> getCachedCurrencies() async {
    final db = await appDatabase.database;
    final maps = await db.query(
      DatabaseTables.currencies,
      orderBy: 'code ASC',
    );
    return maps.map(CurrencyModel.fromMap).toList();
  }

  @override
  Future<void> cacheCurrencies(List<CurrencyModel> currencies) async {
    final db = await appDatabase.database;
    final batch = db.batch();
    for (final currency in currencies) {
      batch.insert(
        DatabaseTables.currencies,
        currency.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }
}
