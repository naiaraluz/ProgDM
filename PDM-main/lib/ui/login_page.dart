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
  

  List<Responsavel> ListaResponsavel = [];

  

  var _emailController = TextEditingController();
  var _senhaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.greenAccent,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Material(
                borderRadius: BorderRadius.all(Radius.circular(90.0)),
                  elevation: 10,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Image.asset(
                      'images/person.jpg',
                      width: 130,
                      height: 130,
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
            )
            ],
          ),
        ), 
      );
  }
  _onClickLogin(BuildContext context, /*int index*/) { 
    if(_emailController.text == "admin"/*ListaResponsavel[index].email*/
      && _senhaController.text == "senha" /*ListaResponsavel[index].senha*/){
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

  

  
}