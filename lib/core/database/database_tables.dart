class DatabaseTables {
  DatabaseTables._();

  static const String currencies = 'currencies';

  static const String createCurrenciesTable = '''
    CREATE TABLE IF NOT EXISTS $currencies (
      code TEXT PRIMARY KEY,
      name TEXT NOT NULL
    )
  ''';
}
