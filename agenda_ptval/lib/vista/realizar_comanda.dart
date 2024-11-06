import 'package:flutter/material.dart';

class RealizarComanda extends StatefulWidget {
  @override
  _RealizarComandaState createState() => _RealizarComandaState();
}

class _RealizarComandaState extends State<RealizarComanda> {
  final List<String> _clases = ['Clase 1', 'Clase 2', 'Clase 3'];
  final List<String> _tiposMenu = ['Menu 1', 'Menu 2', 'Menu 3'];
  final Map<String, Map<String, int>> _comandas = {};

  @override
  void initState() {
    super.initState();
    for (var clase in _clases) {
      _comandas[clase] = {};
      for (var tipoMenu in _tiposMenu) {
        _comandas[clase]![tipoMenu] = 0;
      }
    }
  }

  void _incrementarCantidad(String clase, String tipoMenu) {
    setState(() {
      _comandas[clase]![tipoMenu] = _comandas[clase]![tipoMenu]! + 1;
    });
  }

  void _decrementarCantidad(String clase, String tipoMenu) {
    setState(() {
      if (_comandas[clase]![tipoMenu]! > 0) {
        _comandas[clase]![tipoMenu] = _comandas[clase]![tipoMenu]! - 1;
      }
    });
  }

  void _confirmarComanda() {
    // Aquí puedes agregar la lógica para confirmar la comanda
    print('Comanda confirmada: $_comandas');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Realizar Comanda'),
      ),
      body: ListView(
        children: _clases.map((clase) {
          return Card(
            margin: EdgeInsets.all(10),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    clase,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ..._tiposMenu.map((tipoMenu) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(tipoMenu),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: () => _decrementarCantidad(clase, tipoMenu),
                            ),
                            Text(_comandas[clase]![tipoMenu].toString()),
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () => _incrementarCantidad(clase, tipoMenu),
                            ),
                          ],
                        ),
                      ],
                    );
                  }).toList(),
                ],
              ),
            ),
          );
        }).toList(),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(10),
        child: ElevatedButton(
          onPressed: _confirmarComanda,
          child: Text('Confirmar Comanda'),
        ),
      ),
    );
  }
}