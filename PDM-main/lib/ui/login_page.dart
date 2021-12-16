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
import 'home_page.dart';
import 'lista_categoria_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  ResponsavelConnect _responsavelConnect = ResponsavelConnect();
  ChamadoConnect _chamadoConnect = ChamadoConnect();
  CategoriaConnect _categoriaConnect = CategoriaConnect();


  List<Responsavel> ListaResponsavel = [];

  var _emailController = TextEditingController();
  var _senhaController = TextEditingController();

  set listaChamados(List listaChamados) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.greenAccent,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          reverse: true,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 50.0,
              ),
              Material(
                borderRadius: BorderRadius.all(Radius.circular(100.0)),
                  elevation: 10,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Image.asset(
                      'images/person.jpg',
                      width: 180,
                      height: 180,
                    ),
                  ),
              ),
              SizedBox(
                    height: 10.0,
                  ),
              TextFormField(
                style: TextStyle(color: Colors.black),
                controller: _emailController,
                decoration: InputDecoration(
                  hintStyle: TextStyle(
                    color: Colors.black,
                    fontFamily: "WorkSansLight",
                    fontSize: 15.0),
                  filled: true,
                  fillColor: Colors.white24,
                  hintText: "E-mail",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black, width: 0.5)),
                        prefixIcon: const Icon(
                          Icons.markunread_outlined,
                          color: Colors.black,
                        ),
                    
                  ),
                  onChanged: (text) {
                    setState(() {
                      _emailController = text as TextEditingController;
                    });
                  },
              ),
              SizedBox(
                height: 10.0,
              ),
              TextFormField(
                obscureText: true,
                style: TextStyle(color: Colors.black),
                controller: _senhaController,
                decoration: InputDecoration(
                  hintStyle: TextStyle(
                    color: Colors.black,
                    fontFamily: "WorkSansLight",
                    fontSize: 15.0),
                  filled: true,
                  fillColor: Colors.white24,
                  hintText: "Senha",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black, width: 0.5)),
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: Colors.black,
                    ),
                  ),
                  onChanged: (text) {
                    setState(() {
                      _senhaController = text as TextEditingController;
                    });
                  },
                ),
              Align(
                alignment: Alignment.center,
                  child: ListTile(
                    
                    title: Text('Cadastre-se'),
                      onTap: () {
                        print('Cadastre-se');
                        _showResponsavelPage();
                      },
                    ),
                  ),
            
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 80,
                width: 80,
                child: new FloatingActionButton(
                  backgroundColor: Colors.white,
                  child: Text(
                    "Entrar",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                    ),
                  ),
                onPressed: () { 
                  _onClickLogin(context /*, index*/); //coloquei index aqui antes, mas da erro ainda
                },  
              ),
            ),
            SizedBox(
                height: 50,
              ),
            SizedBox(
                height: 20,
                width: 80,
                child: new RaisedButton(
                  color: Colors.greenAccent,
                  child: Text(
                    "",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 5.0,
                    ),
                  ),
                onPressed: () { 
                  resetarBanco();
                },  
              ),
            )
            ],
          ),
        ),
      ), 
    );
  }
  _onClickLogin(BuildContext context, /*int index*/) async { 
    Responsavel responsavel = await _responsavelConnect.get(_emailController.text, _senhaController.text);
    if(responsavel !=null){
      _showHomePage();
    }else{
        showDialog(context: context,
        builder: (context){
        return AlertDialog(
          title:Text("Erro"),
          content: Text("Login e/ou Senha inválido(s)"),
          actions : <Widget>[
            FlatButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.pop(context);
              }
            )
          ]
        );
      },
      );
      }
    }  
  void _showHomePage(){
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => HomePage()
            ));
  }

  void _getAllResponsavel() {
    _responsavelConnect.getAll().then((list) {
      setState(() {
        var listaResponsavel = list;
      });
      //print(list);
    });
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

    void resetarBanco() async {
    _responsavelConnect.dropTable();
    _responsavelConnect.createTable();

    _categoriaConnect.dropTable();
    _categoriaConnect.createTable();

    _chamadoConnect.dropTable();
    _chamadoConnect.createTable();

    Responsavel responsavel = Responsavel(null, 'Selecione um responsável...', 'responsavel@aluno.ifsc.edu.br', 'senha123');
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

  void _getAllChamados() {
    _chamadoConnect.getAllChamados().then((list) {
      setState(() {
        listaChamados = list;
      });
      //print(list);
    });
  }


  

  
}