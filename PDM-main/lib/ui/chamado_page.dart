import 'package:projeto_banco/models/categoria.dart';
import 'package:projeto_banco/models/chamados.dart';
import 'package:flutter/material.dart';
import 'package:projeto_banco/models/responsavel.dart';

class ChamadoPage extends StatefulWidget {
  final Chamado chamado;
  ChamadoPage({this.chamado});

  @override
  _ChamadoPageState createState() => _ChamadoPageState();
}

class _ChamadoPageState extends State<ChamadoPage> {
  final _tituloController = TextEditingController();
  final _responsavelController = TextEditingController();
  final _interacaoController = TextEditingController();
  final _categoriaController = TextEditingController();

  final _relatorController = TextEditingController();
  final _imgController = TextEditingController();

  final _tituloFocus = FocusNode();
  final _categoriaFocus = FocusNode();

  final _responsavelFocus = FocusNode();

  bool _userEdited = false;
  Chamado _editedChamado;

  ResponsavelConnect responsavelConnect = ResponsavelConnect();
  Responsavel _responsavelSelecionado = Responsavel(null, null, null, null);
  List<DropdownMenuItem<Responsavel>> _listaItensResponsavelDropdown = [];

  CategoriaConnect categoriaConnect = CategoriaConnect();
  Categoria _categoriaSelecionada = Categoria(null, null);
  List<DropdownMenuItem<Categoria>> _listaItensCategoriaDropdown = [];

  String _statusSelecionado = 'Novo';
  List<DropdownMenuItem<String>> _listaItensStatusDropdown = [];

  void carregarItensStatus() {
    List<String> listaStatus = [
      'Novo',
      'Pendente',
      'Em andamento',
      'Finalizado'
    ];

    for (var status in listaStatus) {
      DropdownMenuItem<String> item = DropdownMenuItem<String>(
        value: status,
        child: Text(status),
      );

      setState(() {
        _listaItensStatusDropdown.add(item);
      });
    }
  }

  @override
  void initState() {
    super.initState();

    // Rotas.showCategoriaPage(context);

    carregarItensStatus();

    if (widget.chamado == null) {
      _editedChamado = Chamado();
    } else {
      _editedChamado = widget.chamado;

      _tituloController.text = _editedChamado.titulo;
      _responsavelController.text = _editedChamado.responsavel.nome;
      _interacaoController.text = _editedChamado.interacao;
      _categoriaController.text = _editedChamado.categoria.nome;

      _relatorController.text = _editedChamado.relator;
      _imgController.text = _editedChamado.img;

      setState(() {
        _statusSelecionado = _editedChamado.status;
      });
    }

    _getCarregarCategoria();
    _getCarregarResponsavel();
  }

  _getCarregarCategoria() async {
    List<Categoria> categorias = await categoriaConnect.getAllCategorias();

    _listaItensCategoriaDropdown = [];

    for (var categoria in categorias) {
      DropdownMenuItem<Categoria> item = DropdownMenuItem<Categoria>(
        value: categoria,
        child: Text(categoria.nome),
      );

      _listaItensCategoriaDropdown.add(item);
    }

    setState(() {
      _categoriaSelecionada = _listaItensCategoriaDropdown.first.value;

      // _categoriaSelecionada = _listaItensDropdown
      //     .where((element) => _editedChamado.categoria.id == element.value.id)
      //     .first
      //     .value;

      for (var item in _listaItensCategoriaDropdown) {
        if (_editedChamado.categoria.id == item.value.id) {
          _categoriaSelecionada = item.value;
          break;
        }
      }
    });
  }

  _getCarregarResponsavel() async {
    List<Responsavel> responsavels = await ResponsavelConnect().getAll();

    _listaItensResponsavelDropdown = [];

    for (var responsavel in responsavels) {
      DropdownMenuItem<Responsavel> item = DropdownMenuItem<Responsavel>(
        value: responsavel,
        child: Text(responsavel.nome),
      );

      _listaItensResponsavelDropdown.add(item);
    }

    setState(() {
      try {
        _responsavelSelecionado = _listaItensResponsavelDropdown
            .where(
                (element) => _editedChamado.responsavel.id == element.value.id)
            .first
            .value;
      } catch (e) {
        _responsavelSelecionado = _listaItensResponsavelDropdown.first.value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _requestPop,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.greenAccent,
            title: Text(_editedChamado.titulo ?? "Novo Chamado"),
            centerTitle: true,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (_editedChamado.titulo == null ||
                  _editedChamado.titulo.isEmpty) {
                FocusScope.of(context).requestFocus(_tituloFocus);
                return;
              }
              if (_editedChamado.categoria.nome == null ||
                  _editedChamado.categoria.nome.isEmpty) {
                FocusScope.of(context).requestFocus(_categoriaFocus);
                return;
              }
              Navigator.pop(context, _editedChamado);
            },
            child: Icon(Icons.save),
            backgroundColor: Colors.grey,
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _tituloController,
                  focusNode: _tituloFocus,
                  decoration: InputDecoration(labelText: "Título"),
                  onChanged: (text) {
                    _userEdited = true;
                    setState(() {
                      _editedChamado.titulo = text;
                    });
                  },
                ),
                _dropdownButtonResponsavel(),

                TextField(
                  controller: _interacaoController,
                  decoration: InputDecoration(labelText: "Conteudo"),
                  onChanged: (text) {
                    _userEdited = true;
                    _editedChamado.interacao = text;
                  },
                ),
                _dropdownButtonCategoria(),

                _dropdownButtonStatus(),
                // TextField(
                //   controller: _categoriaController,
                //   focusNode: _categoriaFocus,
                //   decoration: InputDecoration(labelText: "Categoria"),
                //   onChanged: (text) {
                //     _userEdited = true;
                //     _editedChamado.categoria.nome = text;
                //   },
                // ),

                TextField(
                  controller: _relatorController,
                  decoration: InputDecoration(labelText: "Relator"),
                  onChanged: (text) {
                    _userEdited = true;
                    _editedChamado.relator = text;
                  },
                ),
              ],
            ),
          ),
        ));
  }

  _dropdownButtonCategoria() {
    return DropdownButton<Categoria>(
      value: _categoriaSelecionada,
      icon: const Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      isExpanded: true,
      style: const TextStyle(color: Colors.black),
      underline: Container(
        height: 2,
        color: Colors.black,
      ),
      onChanged: (newValue) {
        setState(() {
          _categoriaSelecionada = newValue;
          _userEdited = true;

          _editedChamado.categoria = _categoriaSelecionada;
        });
      },
      items: _listaItensCategoriaDropdown,
    );
  }

  _dropdownButtonStatus() {
    return DropdownButton<String>(
      value: _statusSelecionado,
      icon: const Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      isExpanded: true,
      style: const TextStyle(color: Colors.black),
      underline: Container(
        height: 2,
        color: Colors.black,
      ),
      onChanged: (newValue) {
        setState(() {
          _statusSelecionado = newValue;
          _userEdited = true;

          _editedChamado.status = _statusSelecionado;
        });
      },
      items: _listaItensStatusDropdown,
    );
  }

  _dropdownButtonResponsavel() {
    return DropdownButton<Responsavel>(
      value: _responsavelSelecionado,
      icon: const Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      isExpanded: true,
      style: const TextStyle(color: Colors.black),
      underline: Container(
        height: 2,
        color: Colors.black,
      ),
      onChanged: (newValue) {
        setState(() {
          _responsavelSelecionado = newValue;
          _userEdited = true;

          _editedChamado.responsavel = _responsavelSelecionado;
        });
      },
      items: _listaItensResponsavelDropdown,
    );
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
