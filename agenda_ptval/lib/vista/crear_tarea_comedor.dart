import 'package:flutter/material.dart';
import 'package:agenda_ptval/controlador/tarea_comedor_controller.dart';
import 'package:agenda_ptval/modelo/tarea_comedor_modelo.dart';

class CrearTareaComedor extends StatefulWidget {
  @override
  _CrearTareaComedorState createState() => _CrearTareaComedorState();
}

class _CrearTareaComedorState extends State<CrearTareaComedor> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final TareaComedorController _tareaComedorController = TareaComedorController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Tarea Comedor'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _tituloController,
                decoration: InputDecoration(labelText: 'Título'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un título';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    TareaComedor nuevaTareaComedor = TareaComedor(
                      idTareaComedor: 0, // El ID será asignado por el controlador
                      titulo: _tituloController.text,
                      fecha: DateTime.now(),
                    );

                    await _tareaComedorController.crearTareaComedor(nuevaTareaComedor);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Tarea de comedor creada exitosamente')),
                    );

                    _tituloController.clear();
                  }
                },
                child: Text('Crear Tarea Comedor'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}