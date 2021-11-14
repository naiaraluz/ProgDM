import 'dart:async';
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
    final path = join(databasesPath, "chamados2.db");

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int newerVersion) async {
      await db.execute(
          "CREATE TABLE $responsavelTable($idResponsavel INTEGER PRIMARY KEY, $nomeResponsavel TEXT)");
    });
  }

  Future<Responsavel> saveResponsavel(Responsavel responsavel) async {
    Database dbchamado = await db;
    responsavel.id = await dbchamado.insert(responsavelTable, responsavel.toMap());
    return responsavel;
  }

  Future<Responsavel> getResponsavel(int id) async {
    Database dbchamado = await db;
    List<Map> maps = await dbchamado.query(responsavelTable,
        columns: [idResponsavel, nomeResponsavel],
        where: "$idResponsavel = ?",
        whereArgs: [id]);
    if (maps.length > 0) {
      return Responsavel.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> deleteresponsavel(int id) async {
    Database dbchamado = await db;
    return await dbchamado
        .delete(responsavelTable, where: "$idResponsavel = ?", whereArgs: [id]);
  }

  Future<int> updateresponsavel(Responsavel responsavel) async {
    Database dbchamado = await db;
    return await dbchamado.update(responsavelTable, responsavel.toMap(),
        where: "$idResponsavel = ?", whereArgs: [responsavel.id]);
  }

  Future<List> getAllResponsavel() async {
    Database dbchamado = await db;
    List listMap = await dbchamado.rawQuery("SELECT * FROM $responsavelTable");
    List<Responsavel> listresponsavel = [];

    for (Map m in listMap) {
      listresponsavel.add(Responsavel.fromMap(m));
    }
    return listresponsavel;
  }

  Future<int> getNumber() async {
    Database dbchamado = await db;
    return Sqflite.firstIntValue(
        await dbchamado.rawQuery("SELECT COUNT(*) FROM $responsavelTable"));
  }
  
  Future<void> dropTable() async {
    
    Database dbchamado = await db;
    return await dbchamado.rawQuery("DROP TABLE $responsavelTable");
    
  }

  Future<void> createTable() async {
    
    Database dbchamado = await db;
    return await dbchamado.rawQuery(
        "CREATE TABLE $responsavelTable($idResponsavel INTEGER PRIMARY KEY, $nomeResponsavel TEXT)");
    
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

  //Construtor - quando formos armazenar em nosso bd, vamos armazenar em
  //um formato de mapa e para recuperar os dados, precisamos transformar
  //esse map de volta em nosso contato.
  Responsavel.fromMap(Map map) {
    // nessa função eu pego um map e passo para o meu contato
    id = map[idResponsavel];
    nome = map[nomeResponsavel];
  }

  Map toMap() {
    // aqui eu pego contato e transformo em um map
    Map<String, dynamic> map = {
      idResponsavel: id,
      nomeResponsavel: nome,
    };

    if (id != null) {
      map[idResponsavel] = id;
    }
    return map;
  }

  @override
  String toString() {
    //sobrescrita do método para facilitar a visualização dos dados
    return "Responsavel(id: $id, nome: $nome )";
  }
}
