import 'dart:io';
import 'dart:async';
import 'package:projeto_banco/models/responsavel.dart';
import 'package:projeto_banco/models/categoria.dart';
import 'package:projeto_banco/models/chamados.dart';
import 'package:projeto_banco/ui/chamado_page.dart';
import 'package:projeto_banco/ui/responsavel_page.dart';
import 'package:flutter/material.dart';

import 'categoria_page.dart';
//import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ChamadoConnect chamadoConnect = ChamadoConnect();
  CategoriaConnect categoriaConnect = CategoriaConnect();
  ResponsavelConnect responsavelConnect = ResponsavelConnect();

  List<Chamado> listaChamados = [];

  @override
  void initState() {
    super.initState();



    resetarBanco();

    _getAllChamados();
  }

  void resetarBanco() async {
    categoriaConnect.dropTable();
    categoriaConnect.createTable();

    chamadoConnect.dropTable();
    chamadoConnect.createTable();

    Responsavel responsavel = Responsavel(null, 'responsavel');
    responsavel = await responsavelConnect.saveResponsavel(responsavel);

    Categoria categoria = Categoria(null, 'categoria');
    categoria = await categoriaConnect.saveCategoria(categoria);

    Chamado chamado = Chamado();
    chamado.id = null;
    chamado.titulo = 'titulo';
    chamado.responsavel = responsavel;
    chamado.interacao = 'interacao';
    chamado.categoria = categoria;
    chamado.status = 'status';
    chamado.relator = 'relator';
    chamado.img = '';

    chamado = await chamadoConnect.saveChamado(chamado);

    _getAllChamados();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chamados"),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("pressionou");
          _showChamadoPage();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
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
              leading: Icon(Icons.account_circle),
              title: Text('Responsáveis'),
              subtitle: Text('Cadastro de Responsáveis'),
              onTap: () {
                print('eu');
                _showResponsavelPage();
              },
            ),
            ListTile(
              leading: Icon(Icons.list_alt_sharp),
              title: Text('Categorias'),
              subtitle: Text('Cadastro de Categorias'),
              onTap: () {
                print('eu');
                _showCategoriaPage();
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
                      Text(listaChamados[index].responsavel ?? "",
                          style: TextStyle(fontSize: 18.0)),
                      Text(listaChamados[index].relator ?? "",
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
        await categoriaConnect.updatecategoria(recChamado.categoria);
        await chamadoConnect.updatechamado(recChamado);
      } else {
        await categoriaConnect.saveCategoria(recChamado.categoria);
        await chamadoConnect.saveChamado(recChamado);
      }
      _getAllChamados();
    }
  }

  void _getAllChamados() {
    chamadoConnect.getAllChamados().then((list) {
      setState(() {
        listaChamados = list;
      });
      //print(list);
    });
  }

  void _showCategoriaPage({Categoria categorias}) async {
    final Categoria recCategoria = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CategoriaPage(
                  categorias: categorias,
                )));
    if (recCategoria != null) {
      if (categorias != null) {
        // await statusConnect.updatestatus(recStatus.status);
      } else {
        // await statusConnect.saveStatus(recStatus.status);
      }
      _getAllCategoria();
    }
  }

  void _getAllCategoria() {
    // StatusConnect.getAllStatus().then((list) {
    // setState(() {
    //  listaStatus = list;
    // });
    //print(list);
    // });
  }

  void _showResponsavelPage({Responsavel responsavel}) async {
    final Responsavel recResponsavel = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ResponsavelPage(
                  responsavel: responsavel,
                )));
    if (recResponsavel != null) {
      if (responsavel!= null) {
        // await statusConnect.updatestatus(recStatus.status);
      } else {
        // await statusConnect.saveStatus(recStatus.status);
      }
      _getAllResponsavel();
    }
  }

  void _getAllResponsavel() {
    // StatusConnect.getAllStatus().then((list) {
    // setState(() {
    //  listaStatus = list;
    // });
    //print(list);
    // });
  }


}
