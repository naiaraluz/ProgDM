import 'dart:developer';
import 'dart:io';
import 'dart:async';
import 'package:projeto_banco/models/categoria.dart';
import 'package:projeto_banco/models/chamados.dart';
import 'package:projeto_banco/models/responsavel.dart';
import 'package:projeto_banco/ui/chamado_page.dart';
import 'package:flutter/material.dart';
import 'package:projeto_banco/ui/responsavel_page.dart';

import 'categoria_page.dart';
import 'lista_categoria_page.dart';
import 'lista_responsavel_page.dart';
import 'login_page.dart';
//import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ChamadoConnect _chamadoConnect = ChamadoConnect();
  CategoriaConnect _categoriaConnect = CategoriaConnect();
  ResponsavelConnect _responsavelConnect = ResponsavelConnect();

  List<Chamado> listaChamados = [];

  get categoriaConnect => null;

  get nome => null;

  get responsavel => null;

  set listaCategorias(listaCategorias) {}

  @override
  void initState() {
    super.initState();

    //resetarBanco();

    _getAllChamados();
  }

    void _addCategorias() async {
    await _categoriaConnect.save(Categoria(null, 'Categoria 1'));
    await _categoriaConnect.save(Categoria(null, 'Categoria 2'));
    await _categoriaConnect.save(Categoria(null, 'Categoria 3'));
  }

  void _addResponsavels() async {
    await _responsavelConnect.save(Responsavel(null, 'Responsavel 1', 'teste@teste', '123'));
    await _responsavelConnect.save(Responsavel(null, 'Responsavel 2', 'teste@teste2', '123'));
    await _responsavelConnect.save(Responsavel(null, 'Responsavel 3', 'teste@teste3', '123'));
  }


  void resetarBanco() async {
    _responsavelConnect.dropTable();
    _responsavelConnect.createTable();

    _categoriaConnect.dropTable();
    _categoriaConnect.createTable();

    _chamadoConnect.dropTable();
    _chamadoConnect.createTable();

    Responsavel responsavel = Responsavel(null, 'Selecione um respons??vel...', 'responsavel@aluno.ifsc.edu.br', 'senha123');
    responsavel = await _responsavelConnect.save(responsavel);

    Categoria categoria = Categoria(null, 'Selecione uma categoria...');
    categoria = await _categoriaConnect.save(categoria);
    
    log(_responsavelConnect.getAll().toString());

    Chamado chamado = Chamado();
    chamado.id = null;
    chamado.titulo = 'Formatar';
    chamado.responsavel = responsavel;
    chamado.interacao = 'Formatar computador 22 salda 102';
    chamado.categoria = categoria;
    //chamado.status = 'Novo';
    chamado.relator = 'Marcos Gabriel Fernandes';
    chamado.img = '';

    chamado = await _chamadoConnect.save(chamado);

    _getAllChamados();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chamados"),
        backgroundColor: Colors.greenAccent,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("pressionou");
          _showChamadoPage();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.greenAccent,
      ),
      body: ListView.builder(
          padding: EdgeInsets.all(10.0),
          itemCount: listaChamados.length,
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
              leading: Icon(Icons.home_outlined),
              title: Text('Home'),
              onTap: () {
                print('Listagem Chamados');
                _showChamadoCadastroPage();
              },
            ),
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
              title: Text('Cadastro de Respons??veis'),
              onTap: () {
                print('Cadastro Respons??veis');
                _showResponsavelPage();
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
              title: Text('Listagem de Respons??veis'),
              onTap: () {
                print('Listagem Respons??veis');
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
                      Text(listaChamados[index].titulo ?? "",
                          style: TextStyle(
                              fontSize: 22.0, fontWeight: FontWeight.bold)),
                      Text("Resp: " + listaChamados[index].responsavel.nome ?? "",
                          style: TextStyle(fontSize: 18.0)),
                      Text("Rel: " + listaChamados[index].relator ?? "",
                          style: TextStyle(fontSize: 18.0)),
                      Text("Cat: " + listaChamados[index].categoria.nome ?? "",
                          style: TextStyle(fontSize: 18.0)),
                      Text("Status: " + listaChamados[index].status ?? "",
                          style: TextStyle(fontSize: 18.0)),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        onTap: () {
          _showChamadoPage(chamado: listaChamados[index]);
        });
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

  void _showChamadoCadastroPage(){
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => HomePage()
            ));
  }


  void _showResponsavelCadastroPage(){
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ListaCadastroResponsavelPage()
            ));
  }

  void _showLogoutPage(){
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => LoginPage()
            ));
  }

  void _getAllResponsavel() {
    _responsavelConnect.getAll().then((list) {
      setState(() {
        listaChamados = list;
      });
      //print(list);
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

  void _getAllCategoria() {
    _categoriaConnect.getAllCategorias().then((list) {
    setState(() {
    listaCategorias = list;
     });
    print(list);
     });
  }

  
}
