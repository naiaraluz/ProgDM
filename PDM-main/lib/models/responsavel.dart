import 'dart:async';
import 'dart:developer';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final String responsavelTable = "responsavelTable";
final String idResponsavel = "idResponsavel";
final String nomeResponsavel = "nomeResponsavel";

class ResponsavelConnect {
  static final ResponsavelConnect _instance = ResponsavelConnect.internal();

  factory ResponsavelConnect() => _instance;

  ResponsavelConnect.internal();

  Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "chamados.db");

    return await openDatabase(
      path,
      version: 1,
    );
  }

  Future<Responsavel> save(Responsavel responsavel) async {
    Database dbchamado = await db;
    responsavel.id = await dbchamado.insert(
      responsavelTable,
      responsavel.toMap(),
    );
    return responsavel;
  }

  Future<int> update(Responsavel responsavel) async {
    Database dbchamado = await db;
    return await dbchamado.update(
      responsavelTable,
      responsavel.toMap(),
      where: "$idResponsavel = ?",
      whereArgs: [responsavel.id],
    );
  }

  // Future<Categoria> getCategoria(int id) async {
  //   Database dbchamado = await db;
  //   List<Map> maps = await dbchamado.query(responsavelTable,
  //       columns: [idCategoria, nomeCategoria],
  //       where: "$idCategoria = ?",
  //       whereArgs: [id]);
  //   if (maps.length > 0) {
  //     return Categoria.fromMap(maps.first);
  //   } else {
  //     return null;
  //   }
  // }

  // Future<int> deletecategoria(int id) async {
  //   Database dbchamado = await db;
  //   return await dbchamado
  //       .delete(responsavelTable, where: "$idCategoria = ?", whereArgs: [id]);
  // }

  // Future<List> getAllCategorias() async {
  //   Database dbchamado = await db;
  //   List listMap = await dbchamado.rawQuery("SELECT * FROM $responsavelTable");
  //   List<Categoria> listcategoria = [];

  //   for (Map m in listMap) {
  //     listcategoria.add(Categoria.fromMap(m));
  //   }
  //   return listcategoria;
  // }

  // Future<int> getNumber() async {
  //   Database dbchamado = await db;
  //   return Sqflite.firstIntValue(
  //       await dbchamado.rawQuery("SELECT COUNT(*) FROM $responsavelTable"));
  // }

  Future<void> dropTable() async {
    Database dbchamado = await db;
    return await dbchamado.rawQuery("DROP TABLE IF EXISTS $responsavelTable");
  }

  Future<void> createTable() async {
    Database dbchamado = await db;
    return await dbchamado.rawQuery(
      "CREATE TABLE $responsavelTable($idResponsavel INTEGER PRIMARY KEY, $nomeResponsavel TEXT)",
    );
  }

  Future close() async {
    Database dbchamado = await db;
    dbchamado.close();
  }
}

class Responsavel {
  int id;
  String nome;

  Responsavel(this.id, this.nome);

  Responsavel.fromMap(Map map) {
    id = map[idResponsavel];
    nome = map[nomeResponsavel];
  }

  Map<String, dynamic> toMap() => {
        idResponsavel: id,
        nomeResponsavel: nome,
      };

  @override
  String toString() => "Responsavel (id: $id, nome: $nome )";
}
