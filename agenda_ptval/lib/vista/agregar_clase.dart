import 'package:flutter/material.dart';
import 'package:agenda_ptval/controlador/clase_controller.dart';
import 'package:agenda_ptval/modelo/clase_modelo.dart';

class AgregarClase extends StatefulWidget {
  @override
  _AgregarClaseState createState() => _AgregarClaseState();
}

class _AgregarClaseState extends State<AgregarClase> {
  final _formKey = GlobalKey<FormState>();
  final ClaseController _controller = ClaseController();

  String nombreClase = '';

  void _agregarClase() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Clase nuevaClase = Clase(
        idClase: 0, // Este valor se actualizará en el controlador
        nombre: nombreClase,
      );

      _controller.agregarClase(nuevaClase).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Clase agregada con éxito!')),
        );
        Navigator.pop(context); // Regresar a la vista anterior
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al agregar clase: $error')),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Clase'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Nombre de la Clase'),
                onSaved: (value) => nombreClase = value!,
                validator: (value) => value!.isEmpty ? 'Ingresa el nombre de la clase' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _agregarClase,
                child: Text('Agregar Clase'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}