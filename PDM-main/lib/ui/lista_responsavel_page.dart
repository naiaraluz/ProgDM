import 'dart:io';
import 'dart:async';
import 'package:projeto_banco/models/categoria.dart';
import 'package:projeto_banco/models/chamados.dart';
import 'package:projeto_banco/models/responsavel.dart';
import 'package:projeto_banco/ui/chamado_page.dart';
import 'package:flutter/material.dart';
import 'package:projeto_banco/ui/responsavel_page.dart';

import 'categoria_page.dart';
import 'home_page.dart';
import 'lista_categoria_page.dart';
import 'login_page.dart';


//import 'package:url_launcher/url_launcher.dart';

class ListaCadastroResponsavelPage extends StatefulWidget {
  const ListaCadastroResponsavelPage({Key key}) : super(key: key);

  @override
  _ListaCadastroResponsavelPageState createState() => _ListaCadastroResponsavelPageState();
}

class _ListaCadastroResponsavelPageState extends State<ListaCadastroResponsavelPage> {
  ResponsavelConnect _responsavelConnect = ResponsavelConnect();
  ChamadoConnect _chamadoConnect = ChamadoConnect();
  CategoriaConnect _categoriaConnect = CategoriaConnect();
  

  List<Responsavel> listaResponsavel = [];

  

  set listaCategorias(listaCategorias) {}

  set listaChamados(listaChamados) {}

  

  @override
  void initState() {
    super.initState();

    _getAllResponsavel();
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Responsáveis"),
        backgroundColor: Colors.greenAccent,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("pressionou");
          _showResponsavelPage();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.greenAccent,
      ),
      body: ListView.builder(
          padding: EdgeInsets.all(10.0),
          itemCount: listaResponsavel.length,
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
              leading: Icon(Icons.add_comment_outlined),
              title: Text('Cadastro de Chamados'),
              onTap: () {
                print('Cadastro de Chamados');
                _showChamadoPage();
              },
            ),
            
            ListTile(
              leading: Icon(Icons.add_circle_outline_sharp),
              title: Text('Cadastro de Categorias'),
              onTap: () {
                print('Cadastro Categoria');
                _showCategoriaPage();
              },
            ),
            ListTile(
              leading: Icon(Icons.person_pin_outlined ),
              title: Text('Cadastro de Responsáveis'),
              onTap: () {
                print('Cadastro Responsáveis');
                _showResponsavelPage();
              },
            ),
            ListTile(
              leading: Icon(Icons.list_alt_sharp),
              title: Text('Listagem de Chamados'),
              onTap: () {
                print('Listagem Chamados');
                _showChamadoCadastroPage();
              },
            ),
            ListTile(
              leading: Icon(Icons.list_alt_sharp),
              title: Text('Listagem de Categorias'),
              onTap: () {
                print('Listagem Categorias');
                _showCategoriaCadastroPage();
                _getAllCategoria();
              },
            ),
            ListTile(
              leading: Icon(Icons.list_alt_sharp),
              title: Text('Listagem de Responsáveis'),
              onTap: () {
                print('Listagem Responsáveis');
                _showResponsavelCadastroPage();
                _getAllResponsavel();
              },
            ),
            ListTile(
              leading: Icon(Icons.login_rounded ),
              title: Text('Sair'),
              onTap: () {
                print('Sair');
                _showLogoutPage();
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
                      Text(listaResponsavel[index].nome ?? "",
                          style: TextStyle(
                              fontSize: 22.0, fontWeight: FontWeight.bold)),
                      Text(listaResponsavel[index].email ?? "",
                          style: TextStyle(
                              fontSize: 22.0, fontWeight: FontWeight.normal)),
                      Text(listaResponsavel[index].senha ?? "",
                          style: TextStyle(
                              fontSize: 22.0, fontWeight: FontWeight.normal)),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        onTap: () {
          _showResponsavelPage(responsavel: listaResponsavel[index]);
        }
        );
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

  

  void _showChamadoPage({Chamado chamado}) async {
    final Chamado recChamado = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChamadoPage(
                  chamado: chamado,
                )));
    if (recChamado != null) {
      if (chamado != null) {
        //await _responsavelConnect.update(recChamado.responsavel);
        //await _categoriaConnect.update(recChamado.categoria);
        await _chamadoConnect.update(recChamado);
      } else {
        //await _responsavelConnect.save(recChamado.responsavel);
        //await _categoriaConnect.save(recChamado.categoria);
        await _chamadoConnect.save(recChamado);
      }
      _getAllChamados();
    }
  }

  void _showResponsavelPage({Responsavel responsavel}) async {
      final recResponsavel = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ResponsavelPage(
                    responsaveis: responsavel,
                  )));
      if (recResponsavel != null) {
        if (responsavel != null) {
          await _responsavelConnect.update(recResponsavel);
        } else {
          await _responsavelConnect.save(recResponsavel);
        }
        _getAllResponsavel();
      }
    }

  void _showCategoriaCadastroPage(){
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ListaCadastroCategoriaPage()
            ));
  }

  void _showResponsavelCadastroPage(){
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ListaCadastroResponsavelPage()
            ));
  }

  

   void _showChamadoCadastroPage(){
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => HomePage()
            ));
  }

  void _showLogoutPage(){
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => LoginPage()
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

  void _getAllChamados() {
    _chamadoConnect.getAllChamados().then((list) {
      setState(() {
        listaChamados = list;
      });
      //print(list);
    });
  }

  void _getAllResponsavel() {
    _responsavelConnect.getAll().then((list) {
      setState(() {
        listaResponsavel = list;
      });
      //print(list);
    });
  }


  
}
