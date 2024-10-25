import 'dart:convert';
import 'package:agenda_ptval/controlador/clase_controller.dart';
import 'package:flutter/material.dart';
import 'package:agenda_ptval/modelo/estudiante_modelo.dart';
import 'package:agenda_ptval/modelo/clase_modelo.dart';
import 'package:agenda_ptval/controlador/estudiante_controller.dart';
import 'package:crypto/crypto.dart';
import 'package:intl/intl.dart'; // para formatear la fecha

class RegistroEstudiante extends StatefulWidget {
  @override
  _RegistroEstudianteState createState() => _RegistroEstudianteState();
}

class _RegistroEstudianteState extends State<RegistroEstudiante> {
  final _formKey = GlobalKey<FormState>();
  final EstudianteController _controller = EstudianteController();
  final ClaseController _claseController = ClaseController();

  String nombre = '';
  String apellidos = '';
  DateTime? fechaNacimiento;
  String gradoAprendizaje = 'bajo'; // Valor predeterminado
  String? claseAsignada;
  String imagen = '';
  String contrasena = '';

  List<Clase> clases = []; // Lista para almacenar las clases

  @override
  void initState() {
    super.initState();
    _cargarClases(); // Cargar clases al inicializar el estado
  }

  // Método para cargar clases
  Future<void> _cargarClases() async {
    List<Clase> clasesObtenidas = await _claseController.obtenerClases();
    setState(() {
      clases = clasesObtenidas;
    });
  }

  String hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: fechaNacimiento ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != fechaNacimiento) {
      setState(() {
        fechaNacimiento = picked;
      });
    }
  }

  void _registrar() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Estudiante nuevoEstudiante = Estudiante(
        idEstudiante: 0, // Este valor se actualizará en el controlador
        nombre: nombre,
        apellidos: apellidos,
        fechaNacimiento: fechaNacimiento!,
        gradoAprendizaje: gradoAprendizaje,
        idClase: int.parse(claseAsignada!), // Guardamos el ID de la clase
        idHistorial: 0, // Este valor se actualizará en el controlador
        contrasena: hashPassword(contrasena),
      );

      _controller.registrarEstudiante(nuevoEstudiante).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Estudiante registrado con éxito!')),
        );
        Navigator.pop(context); // Volver a la página anterior
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al registrar: $error')),
        );
      });
    }
  }

  Widget _buildTextFormField({
    required String labelText,
    required Function(String?) onSaved,
    required String? Function(String?) validator,
    bool obscureText = false,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: labelText,
        border:const OutlineInputBorder(),
      ),
      onSaved: onSaved,
      validator: validator,
      obscureText: obscureText,
    );
  }

  Widget _buildDropdownButtonFormField({
    required String labelText,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: labelText,
        border:const OutlineInputBorder(),
      ),
      items: items.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildClaseDropdownButtonFormField() {
    return DropdownButtonFormField<String>(
      value: claseAsignada,
      decoration:const InputDecoration(
        labelText: 'Clase Asignada',
        border: OutlineInputBorder(),
      ),
      items: clases.map((Clase clase) {
        return DropdownMenuItem<String>(
          value: clase.idClase.toString(), // Aquí guardamos el ID de la clase
          child: Text(clase.nombre), // Aquí mostramos el nombre de la clase
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          claseAsignada = value; // Aquí asignamos el ID de la clase seleccionada
        });
      },
      validator: (value) => value == null ? 'Selecciona una clase' : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text('Registro de Estudiante'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextFormField(
                labelText: 'Nombre',
                onSaved: (value) => nombre = value!,
                validator: (value) => value!.isEmpty ? 'Ingresa un nombre' : null,
              ),
              const SizedBox(height: 16),
              _buildTextFormField(
                labelText: 'Apellidos',
                onSaved: (value) => apellidos = value!,
                validator: (value) => value!.isEmpty ? 'Ingresa apellidos' : null,
              ),
              const SizedBox(height: 16),
              ListTile(
                title: Text(
                  fechaNacimiento == null
                      ? 'Fecha de Nacimiento'
                      : 'Fecha de Nacimiento: ${DateFormat('dd-MM-yyyy').format(fechaNacimiento!)}',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context),
              ),
              const SizedBox(height: 16),
              _buildDropdownButtonFormField(
                labelText: 'Grado de Aprendizaje',
                value: gradoAprendizaje,
                items: ['bajo', 'medio', 'alto'],
                onChanged: (value) {
                  setState(() {
                    gradoAprendizaje = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              _buildClaseDropdownButtonFormField(),
              const SizedBox(height: 16),
              _buildTextFormField(
                labelText: 'URL de Imagen',
                onSaved: (value) => imagen = value!,
                validator: (value) => value!.isEmpty ? 'Ingresa una URL de imagen' : null,
              ),
              const SizedBox(height: 16),
              _buildTextFormField(
                labelText: 'Contraseña',
                onSaved: (value) => contrasena = value!,
                validator: (value) => value!.isEmpty ? 'Ingresa una contraseña' : null,
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _registrar,
                child: const Text('Registrar Estudiante'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}