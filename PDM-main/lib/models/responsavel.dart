import 'dart:async';
import 'dart:developer';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final String responsavelTable = "responsavelTable";
final String idResponsavel = "idResponsavel";
final String nomeResponsavel = "nomeResponsavel";
final String emailResponsavel = "emailResponsavel";
final String senhaResponsavel = "senhaResponsavel";

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

  Future<List> getAll() async {
  Database dbchamado = await db;
  List listMap = await dbchamado.rawQuery("SELECT * FROM $responsavelTable");
  List<Responsavel> listresponsavel = [];

    for (Map m in listMap) {
     listresponsavel.add(Responsavel.fromMap(m));
    }
    
    return listresponsavel;
  }

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
      "CREATE TABLE IF NOT EXISTS $responsavelTable($idResponsavel INTEGER PRIMARY KEY, $nomeResponsavel TEXT, $emailResponsavel TEXT, $senhaResponsavel TEXT)",
    );
  }

  Future<Responsavel> get(String email, String senha) async {
    Database dbchamado = await db;

    String query =
        "SELECT * FROM $responsavelTable WHERE $emailResponsavel = '$email' AND $senhaResponsavel = '$senha'";

    List list = await dbchamado.rawQuery(query);

    if (list.isEmpty) {
      return null;
    } else {
      Map map = list.first;
      return Responsavel.fromMap(map);
    }
  }

  Future close() async {
    Database dbchamado = await db;
    dbchamado.close();
  }
}

class Responsavel {
  int id;
  String nome;
  String email;
  String senha;

  Responsavel(this.id, this.nome, this.email, this.senha);

  Responsavel.fromMap(Map map) {
    id = map[idResponsavel];
    nome = map[nomeResponsavel];
    email = map[emailResponsavel];
    senha = map[senhaResponsavel];
  }

  Map<String, dynamic> toMap() => {
        idResponsavel: id,
        nomeResponsavel: nome,
        emailResponsavel: email,
        senhaResponsavel: senha,
      };

  @override
  String toString() => "Responsavel (id: $id, nome: $nome, email: $email, senha: $senha )";
}


