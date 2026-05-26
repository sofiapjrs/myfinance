import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('myfinance.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(
      path,
      version: 3,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE despesas_fixas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        valor TEXT NOT NULL,
        categoria TEXT NOT NULL,
        data TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE metas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        objetivo TEXT NOT NULL,
        guardado TEXT NOT NULL,
        data TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE transacoes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        tipo TEXT NOT NULL,
        nome TEXT NOT NULL,
        valor TEXT NOT NULL,
        categoria TEXT NOT NULL,
        data TEXT NOT NULL,
        descricao TEXT
      )
    ''');
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE metas (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          nome TEXT NOT NULL,
          objetivo TEXT NOT NULL,
          guardado TEXT NOT NULL,
          data TEXT NOT NULL
        )
      ''');
    }

    if (oldVersion < 3) {
      await db.execute('''
        CREATE TABLE transacoes (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          tipo TEXT NOT NULL,
          nome TEXT NOT NULL,
          valor TEXT NOT NULL,
          categoria TEXT NOT NULL,
          data TEXT NOT NULL,
          descricao TEXT
        )
      ''');
    }
  }

  // DESPESAS FIXAS

  Future<int> inserirDespesa(Map<String, String> despesa) async {
    final db = await instance.database;
    return await db.insert('despesas_fixas', despesa);
  }

  Future<List<Map<String, dynamic>>> listarDespesas() async {
    final db = await instance.database;
    return await db.query('despesas_fixas');
  }

  Future<int> atualizarDespesa(
    int id,
    Map<String, String> despesa,
  ) async {
    final db = await instance.database;

    return await db.update(
      'despesas_fixas',
      despesa,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deletarDespesa(int id) async {
    final db = await instance.database;

    return await db.delete(
      'despesas_fixas',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // METAS

  Future<int> inserirMeta(Map<String, String> meta) async {
    final db = await instance.database;
    return await db.insert('metas', meta);
  }

  Future<List<Map<String, dynamic>>> listarMetas() async {
    final db = await instance.database;
    return await db.query('metas');
  }

  Future<int> atualizarMeta(
    int id,
    Map<String, String> meta,
  ) async {
    final db = await instance.database;

    return await db.update(
      'metas',
      meta,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deletarMeta(int id) async {
    final db = await instance.database;

    return await db.delete(
      'metas',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // TRANSAÇÕES

  Future<int> inserirTransacao(Map<String, String> transacao) async {
    final db = await instance.database;
    return await db.insert('transacoes', transacao);
  }

  Future<List<Map<String, dynamic>>> listarTransacoes() async {
    final db = await instance.database;
    return await db.query('transacoes');
  }

  Future<int> atualizarTransacao(
    int id,
    Map<String, String> transacao,
  ) async {
    final db = await instance.database;

    return await db.update(
      'transacoes',
      transacao,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deletarTransacao(int id) async {
    final db = await instance.database;

    return await db.delete(
      'transacoes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
