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
    await db.execute(_rotas);
    await db.execute(_caminhoes);
    await db.execute(_produtores);
  }

  String get _coletas => '''
    CREATE TABLE agl_coleta(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      data_mov TEXT,
      rota_coleta INT,
      rota_nome TEXT,
      km_inicio INT,
      km_fim INT,
      dt_hora_ini TEXT,
      dt_hora_fim TEXT,
      transportador TEXT,
      placa TEXT,
      motorista TEXT,
      ccusto INT,
      rota_finalizada INT,
      enviada INT
    )
  ''';

  String get _tiket => '''
    CREATE TABLE agl_tiket_entrada(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      id_coleta INT,
      clifor INT,
      uf TEXT,
      municipios TEXT,
      nome TEXT,
      produto INT,
      data TEXT,
      tiket INT,
      quantidade INT,
      per_desconto REAL,
      ccusto INT,
      rota_coleta INT,
      crioscopia REAL,
      alizarol INT,
      hora TEXT,
      particao INT,
      observacao TEXT,
      placa TEXT,
      temperatura REAL
    )
  ''';

  String get _rotas => '''
    CREATE TABLE rotas(
      id INT,
      descricao TEXT,
      transportador TEXT,
      rota_finalizada INT
    )
  ''';

  String get _caminhoes => '''
    CREATE TABLE caminhoes(
      placa TEXT,
      descricao TEXT
    )
  ''';

  String get _produtores => '''
    CREATE TABLE produtores(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      clifor INT,
      rota INT,
      nome TEXT,
      municipios TEXT,
      uf TEXT
    )
  ''';
}
