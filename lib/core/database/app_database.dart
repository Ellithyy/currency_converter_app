import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'database_tables.dart';

class AppDatabase {
  static Database? _db;

  Future<Database> get database async {
    _db ??= await _open();
    return _db!;
  }

  Future<Database> _open() async {
    final path = join(await getDatabasesPath(), 'currency_converter.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, _) async {
        await db.execute(DatabaseTables.createCurrenciesTable);
      },
    );
  }
}
