import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../controlador/clase_controller.dart';
import '../controlador/tarea_comedor_controller.dart';
import '../controlador/estudiante_controller.dart';
import '../modelo/clase_modelo.dart';
import '../modelo/estudiante_modelo.dart';

class AsignarTareaComedor extends StatefulWidget {
  @override
  _AsignarTareaComedorState createState() => _AsignarTareaComedorState();
}

class _AsignarTareaComedorState extends State<AsignarTareaComedor> {
  final TareaComedorController _tareaComedorController = TareaComedorController();
  final ClaseController _claseController = ClaseController();
  final EstudianteController _estudianteController = EstudianteController();

  String? _selectedTarea;
  String? _selectedClase;
  String? _selectedEstudiante;
  List<Estudiante> _estudiantes = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Asignar Tarea Comedor'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildTareasDropdown(),
                  const SizedBox(height: 20),
                  _buildClasesDropdown(),
                  const SizedBox(height: 20),
                  _buildEstudiantesDropdown(),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _selectedClase == null || _selectedTarea == null || _selectedEstudiante == null
                        ? null
                        : () {
                            _asignarTarea();
                          },
                    child: Text('Asignar Tarea a la Clase Seleccionada'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      textStyle: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildTareasDropdown() {
    return FutureBuilder<List<DocumentSnapshot>>(
      future: _tareaComedorController.fetchTareasComedor(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error al cargar tareas'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No hay tareas de comedor disponibles'));
        } else {
          return DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: 'Selecciona una tarea de comedor',
              border: OutlineInputBorder(),
            ),
            value: _selectedTarea,
            onChanged: (String? newValue) {
              setState(() {
                _selectedTarea = newValue;
              });
            },
            items: snapshot.data!.map((DocumentSnapshot document) {
              return DropdownMenuItem<String>(
                value: document.id,
                child: Text(document['titulo']),
              );
            }).toList(),
          );
        }
      },
    );
  }

  Widget _buildClasesDropdown() {
    return FutureBuilder<List<Clase>>(
      future: _claseController.obtenerClases(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error al cargar clases'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No hay clases disponibles'));
        } else {
          return DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: 'Selecciona una clase',
              border: OutlineInputBorder(),
            ),
            value: _selectedClase,
            onChanged: (String? newValue) {
              setState(() {
                _selectedClase = newValue;
                _selectedEstudiante = null; // Resetear el estudiante seleccionado
                _fetchEstudiantesPorClase(newValue!);
              });
            },
            items: snapshot.data!.map((Clase clase) {
              return DropdownMenuItem<String>(
                value: clase.idClase.toString(),
                child: Text(clase.nombre),
              );
            }).toList(),
          );
        }
      },
    );
  }

  Widget _buildEstudiantesDropdown() {
    return _estudiantes.isEmpty
        ? Center(child: Text('No hay estudiantes disponibles'))
        : DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: 'Selecciona un estudiante',
              border: OutlineInputBorder(),
            ),
            value: _selectedEstudiante,
            onChanged: (String? newValue) {
              setState(() {
                _selectedEstudiante = newValue;
              });
            },
            items: _estudiantes.map((Estudiante estudiante) {
              return DropdownMenuItem<String>(
                value: estudiante.idEstudiante.toString(),
                child: Text(estudiante.nickname),
              );
            }).toList(),
          );
  }

  void _fetchEstudiantesPorClase(String claseId) async {
    setState(() {
      _isLoading = true;
    });
    List<Estudiante> estudiantes = await _estudianteController.obtenerEstudiantesPorClase(claseId);
    setState(() {
      _estudiantes = estudiantes;
      _isLoading = false;
    });
  }

  void _asignarTarea() {
    if (_selectedClase != null && _selectedTarea != null && _selectedEstudiante != null) {
      _tareaComedorController.asignarTarea(_selectedTarea!, _selectedEstudiante!);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tarea asignada correctamente')),
      );
      Future.delayed(Duration(seconds: 2), () {
        Navigator.pop(context);
      });
    }
  }
}