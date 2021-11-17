import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


final String categoriasTable = "categoriasTable";
final String idCategoria = "idCategoria";
final String nomeCategoria = "nomeCategoria";

class CategoriaConnect {
  static final CategoriaConnect _instance = CategoriaConnect.internal();

  factory CategoriaConnect() => _instance;

  CategoriaConnect.internal();

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

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int newerVersion) async {
      await db.execute(
          "CREATE TABLE $categoriasTable($idCategoria INTEGER PRIMARY KEY, $nomeCategoria TEXT)");
    });
  }

  Future<Categoria> save(Categoria categoria) async {
    Database dbchamado = await db;
    categoria.id = await dbchamado.insert(categoriasTable, categoria.toMap());
    return categoria;
  }

  Future<Categoria> getCategoria(int id) async {
    Database dbchamado = await db;
    List<Map> maps = await dbchamado.query(categoriasTable,
        columns: [idCategoria, nomeCategoria],
        where: "$idCategoria = ?",
        whereArgs: [id]);
    if (maps.length > 0) {
      return Categoria.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> deletecategoria(int id) async {
    Database dbchamado = await db;
    return await dbchamado
        .delete(categoriasTable, where: "$idCategoria = ?", whereArgs: [id]);
  }

  Future<int> update(Categoria categoria) async {
    Database dbchamado = await db;
    return await dbchamado.update(categoriasTable, categoria.toMap(),
        where: "$idCategoria = ?", whereArgs: [categoria.id]);
  }

  Future<List> getAllCategorias() async {
    Database dbchamado = await db;
    List listMap = await dbchamado.rawQuery("SELECT * FROM $categoriasTable");
    List<Categoria> listcategoria = [];

    for (Map m in listMap) {
      listcategoria.add(Categoria.fromMap(m));
    }
    return listcategoria;
  }

  Future<int> getNumber() async {
    Database dbchamado = await db;
    return Sqflite.firstIntValue(
        await dbchamado.rawQuery("SELECT COUNT(*) FROM $categoriasTable"));
  }

  Future<void> dropTable() async {
    
    Database dbchamado = await db;
    return await dbchamado.rawQuery("DROP TABLE $categoriasTable");
    
  }

  Future<void> createTable() async {
    
    Database dbchamado = await db;
    return await dbchamado.rawQuery(
        "CREATE TABLE $categoriasTable($idCategoria INTEGER PRIMARY KEY, $nomeCategoria TEXT)");
    
  }

  Future close() async {
    Database dbchamado = await db;
    dbchamado.close();
  }
}

class Categoria {
  int id;
  String nome;

  Categoria(this.id, this.nome);

  //Construtor - quando formos armazenar em nosso bd, vamos armazenar em
  //um formato de mapa e para recuperar os dados, precisamos transformar
  //esse map de volta em nosso contato.
  Categoria.fromMap(Map map) {
    // nessa função eu pego um map e passo para o meu contato
    id = map[idCategoria];
    nome = map[nomeCategoria];
  }

  Map toMap() {
    // aqui eu pego contato e transformo em um map
    Map<String, dynamic> map = {
      idCategoria: id,
      nomeCategoria: nome,
    };

    if (id != null) {
      map[idCategoria] = id;
    }
    return map;
  }

  @override
  String toString() {
    //sobrescrita do método para facilitar a visualização dos dados
    return "Categoria(id: $id, nome: $nome )";
  }
}
