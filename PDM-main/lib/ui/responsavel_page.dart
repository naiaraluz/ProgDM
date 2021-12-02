
import 'package:flutter/material.dart';
import 'package:projeto_banco/models/responsavel.dart';

class ResponsavelPage extends StatefulWidget {
  final Responsavel responsaveis;
  ResponsavelPage({this.responsaveis});

  @override
  _ResponsavelPageState createState() => _ResponsavelPageState();
}

class _ResponsavelPageState extends State<ResponsavelPage> {

  ResponsavelConnect responsavelConnect = ResponsavelConnect();
  
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  final _nomeFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _senhaFocus = FocusNode();

  bool _userEdited = false;
  Responsavel _editedResponsavel = Responsavel(null, 'responsavel', 'email', 'senha');

  

  @override
  void initState() {
    super.initState();

    if (widget.responsaveis == null) {
      _editedResponsavel = Responsavel(null, 'Novo Responsável', null, null);
    } else {
      _editedResponsavel = Responsavel.fromMap(widget.responsaveis.toMap());

      _nomeController.text = _editedResponsavel.nome;
      _emailController.text = _editedResponsavel.email;
      _senhaController.text = _editedResponsavel.senha;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _requestPop,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.greenAccent,
            title: Text(_editedResponsavel.nome ?? "Novo Responsável"),
            centerTitle: true,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (_editedResponsavel.nome == null ||
                  _editedResponsavel.nome.isEmpty) {
                FocusScope.of(context).requestFocus(_nomeFocus);
                return;
              }
              Navigator.pop(context, _editedResponsavel);
            },
            child: Icon(Icons.save),
            backgroundColor: Colors.greenAccent,
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: [
                TextField(
                  controller: _nomeController,
                  focusNode: _nomeFocus,
                  decoration: InputDecoration(labelText: "Nome"),
                  onChanged: (text) {
                    _userEdited = true;
                    setState(() {
                      _editedResponsavel.nome = text;
                      
                    });
                  },
                ),
                TextField(
                  controller: _emailController,
                  focusNode: _emailFocus,
                  decoration: InputDecoration(labelText: "E-mail"),
                  onChanged: (text) {
                    _userEdited = true;
                    setState(() {
                      _editedResponsavel.email = text;
                      
                    });
                  },
                ),
                TextField(
                  controller: _senhaController,
                  focusNode: _senhaFocus,
                  decoration: InputDecoration(labelText: "Senha"),
                  obscureText: true,
                  onChanged: (text) {
                    _userEdited = true;
                    setState(() {
                      _editedResponsavel.senha = text;
                      
                    });
                  },
                ),
                
              ],
            ),
          ),
        ));
  }

  Future<bool> _requestPop() {
    if (_userEdited) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Descartar Alterações?"),
              content: Text("Se sair as alterações serão perdidas."),
              actions: [
                FlatButton(
                    child: Text("Cancelar"),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                FlatButton(
                    child: Text("Sim"),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    })
              ],
            );
          });
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

  
}