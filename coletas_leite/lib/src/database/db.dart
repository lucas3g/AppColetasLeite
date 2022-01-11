import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DB {
  DB._();

  static final DB instance = DB._();

  static Database? _database;

  get database async {
    if (_database != null) return _database;

    return await _initDatabase();
  }

  _initDatabase() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'ADM.db'),
      version: 1,
      onCreate: _onCreate,
    );
  }

  _onCreate(db, versao) async {
    await db.execute(_coletas);
    await db.execute(_tiket);
  }

  String get _coletas => '''
    CREATE TABLE agl_coleta(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      data_mov TEXT,
      rota_coleta INT,
      km_inicio INT,
      km_fim INT,
      dt_hora_ini TEXT,
      dt_hora_fim TEXT,
      transportador TEXT,
      motorista TEXT,
      ccusto INT,
      rota_finalizada INT
    )
  ''';

  String get _tiket => '''
    CREATE TABLE agl_tiket_entrada(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      clifor INT,
      produto INT,
      data text,
      tiket INT,
      quantidade INT,
      per_desconto REAL,
      ccusto INT,
      rota_coleta INT,
      crioscopia REAL,
      hora TEXT,
      particao INT,
      observacao TEXT,
      temperatura REAL
    )
  ''';
}
