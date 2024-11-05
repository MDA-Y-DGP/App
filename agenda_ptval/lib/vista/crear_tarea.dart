import 'package:flutter/material.dart';
import 'package:agenda_ptval/modelo/tarea_modelo.dart';
import 'package:agenda_ptval/controlador/tarea_controller.dart';

class CrearTarea extends StatefulWidget {
  @override
  _CrearTareaState createState() => _CrearTareaState();
}

class _CrearTareaState extends State<CrearTarea> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _descripcionController = TextEditingController();
  final TareaController _tareaController = TareaController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Tarea'),
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
              TextFormField(
                controller: _descripcionController,
                decoration: InputDecoration(labelText: 'Descripción'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese una descripción';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    Tarea nuevaTarea = Tarea(
                      idTarea: 0, // El ID será asignado por el controlador
                      titulo: _tituloController.text,
                      descripcion: _descripcionController.text,
                    );

                    await _tareaController.crearTarea(nuevaTarea);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Tarea creada exitosamente')),
                    );

                    _tituloController.clear();
                    _descripcionController.clear();
                  }
                },
                child: Text('Crear Tarea'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}