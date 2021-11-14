import 'package:projeto_banco/models/responsavel.dart';
import 'package:flutter/material.dart';

class ResponsavelPage extends StatefulWidget {
  final Responsavel responsavel;
  ResponsavelPage({this.responsavel});

  @override
  _ResponsavelPageState createState() => _ResponsavelPageState();
}

class _ResponsavelPageState extends State<ResponsavelPage> {
  final _nomeController = TextEditingController();

  final _nomeFocus = FocusNode();

  bool _userEdited = false;
  Responsavel _editedResponsavel;

  @override
  void initState() {
    super.initState();

    if (widget == null) {
      _editedResponsavel = Responsavel(0, '_nomeController');
    } else {
      _editedResponsavel = Responsavel.fromMap(widget.responsavel.toMap());

      _nomeController.text = _editedResponsavel.nome;
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
              if (_editedResponsavel.nome == null || _editedResponsavel.nome.isEmpty) {
                FocusScope.of(context).requestFocus(_nomeFocus);
                return;
              }
              //if (_editedStatus.status.nome == null ||
              //    _editedStatus.status.nome.isEmpty) {
              // FocusScope.of(context).requestFocus(_statusFocus);
              //return;
              //}
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