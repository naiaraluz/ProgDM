import 'dart:io';
import 'dart:async';
import 'package:projeto_banco/models/categoria.dart';
import 'package:projeto_banco/models/chamados.dart';
import 'package:projeto_banco/models/responsavel.dart';
import 'package:projeto_banco/ui/chamado_page.dart';
import 'package:flutter/material.dart';

import 'categoria_page.dart';
import 'home_page.dart';


//import 'package:url_launcher/url_launcher.dart';

class ListaCadastroCategoriaPage extends StatefulWidget {
  const ListaCadastroCategoriaPage({Key key}) : super(key: key);

  @override
  _ListaCadastroCategoriaPageState createState() => _ListaCadastroCategoriaPageState();
}

class _ListaCadastroCategoriaPageState extends State<ListaCadastroCategoriaPage> {
  CategoriaConnect _categoriaConnect = CategoriaConnect();
  

  List<Categoria> listaCategorias = [];

  get categoriaConnect => null;

  @override
  void initState() {
    super.initState();

    _getAllCategoria();
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Categorias"),
        backgroundColor: Colors.greenAccent,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("pressionou");
          _showCategoriaPage();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.greenAccent,
      ),
      body: ListView.builder(
          padding: EdgeInsets.all(10.0),
          itemCount: listaCategorias.length,
          itemBuilder: (context, index) {
            return _chamadoCard(context, index);
          }),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: <Color>[Colors.greenAccent, Colors.white30])),
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Material(
                        borderRadius: BorderRadius.all(Radius.circular(50.0)),
                        elevation: 10,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Image.asset(
                            'images/person.jpg',
                            width: 80,
                            height: 80,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Helpdesk IFSC',
                          style: TextStyle(color: Colors.black, fontSize: 20.0),
                        ),
                      )
                    ],
                  ),
                )),
            ListTile(
              leading: Icon(Icons.list_alt_sharp),
              title: Text('Categorias'),
              subtitle: Text('Cadastro de Categorias'),
              onTap: () {
                print('Cadastro Categoria');
                _showCategoriaPage();
              },
            ),
            ListTile(
              leading: Icon(Icons.list_alt_sharp),
              title: Text('Categorias'),
              subtitle: Text('Listagem de Categorias'),
              onTap: () {
                print('Listagem Categorias');
                _showCategoriaCadastroPage();
                _getAllCategoria();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _chamadoCard(BuildContext context, int index) {
    return GestureDetector(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(listaCategorias[index].nome ?? "",
                          style: TextStyle(
                              fontSize: 22.0, fontWeight: FontWeight.bold)),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        onTap: () {
          _showCategoriaPage(categoria: listaCategorias[index]);
        });
  }

  

  void _showCategoriaPage({Categoria categoria}) async {
      final recCategoria = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CategoriaPage(
                    categorias: categoria,
                  )));
      if (recCategoria != null) {
        if (categoria != null) {
          await _categoriaConnect.update(recCategoria);
        } else {
          await _categoriaConnect.save(recCategoria);
        }
        _getAllCategoria();
      }
    }

  void _showCategoriaCadastroPage(){
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ListaCadastroCategoriaPage()
            ));
  }

  void _getAllCategoria() {
    _categoriaConnect.getAllCategorias().then((list) {
    setState(() {
    listaCategorias = list;
     });
    print(list);
     });
  }
}
