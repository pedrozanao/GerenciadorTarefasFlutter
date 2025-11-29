import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../models/tarefa.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  // ---- GETTER DO BANCO ----
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB("tarefas_RA202310249.db");
    return _database!;
  }

  // ---- INIT DB ----
  Future<Database> _initDB(String fileName) async {
    final dir = await getApplicationDocumentsDirectory();
    final path = join(dir.path, fileName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  // ---- CREATE TABLE ----
  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tarefas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titulo TEXT NOT NULL,
        descricao TEXT NOT NULL,
        prioridade TEXT NOT NULL,
        categoriaProcesso TEXT NOT NULL,
        criadoEm TEXT NOT NULL
      )
    ''');
  }

  // ---- INSERT (RETORNA O ID GERADO) ----
  Future<int> inserirTarefa(Map<String, dynamic> data) async {
    final db = await instance.database;
    return await db.insert("tarefas", data);
  }

  // ---- SELECT ALL ----
  Future<List<Tarefa>> listarTarefas() async {
    final db = await instance.database;
    final result = await db.query("tarefas", orderBy: "id DESC");

    return result.map((json) => Tarefa.fromMap(json)).toList();
  }

  // ---- SELECT BY ID ----
  Future<Tarefa?> buscarTarefa(int id) async {
    final db = await instance.database;

    final result = await db.query(
      "tarefas",
      where: "id = ?",
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return Tarefa.fromMap(result.first);
    }

    return null;
  }

  // ---- UPDATE ----
  Future<int> atualizarTarefa(Map<String, dynamic> data) async {
    final db = await instance.database;

    return await db.update(
      "tarefas",
      data,
      where: "id = ?",
      whereArgs: [data["id"]],
    );
  }

  // ---- DELETE ----
  Future<int> excluirTarefa(int id) async {
    final db = await instance.database;

    return await db.delete(
      "tarefas",
      where: "id = ?",
      whereArgs: [id],
    );
  }

  // ---- CLOSE ----
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
