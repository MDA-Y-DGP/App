import 'package:flutter/material.dart';
import 'package:agenda_ptval/controlador/tarea_controller.dart';
import 'package:agenda_ptval/modelo/tarea_modelo.dart';

class CrearTarea extends StatefulWidget {
  @override
  _CrearTareaState createState() => _CrearTareaState();
}

class _CrearTareaState extends State<CrearTarea> {
  final _formKey = GlobalKey<FormState>();
  final TareaController _tareaController = TareaController();

  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  String _tipo = 'comedor'; // Valor predeterminado

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
                decoration: InputDecoration(
                  labelText: 'Título',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa un título';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descripcionController,
                decoration: InputDecoration(
                  labelText: 'Descripción',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa una descripción';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _tipo,
                decoration: InputDecoration(
                  labelText: 'Tipo de Tarea',
                  border: OutlineInputBorder(),
                ),
                items: ['comedor'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _tipo = newValue!;
                  });
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    Tarea nuevaTarea = Tarea(
                      idTarea: 0, // Este valor se actualizará en el controlador
                      titulo: _tituloController.text,
                      descripcion: _descripcionController.text,
                      tipo: _tipo,
                    );
                    await _tareaController.crearTarea(nuevaTarea);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Tarea creada correctamente')),
                    );
                    Navigator.pop(context);
                  }
                },
                child: const Text('Crear Tarea'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}