import 'dart:convert';
import 'package:agenda_ptval/controlador/clase_controller.dart';
import 'package:flutter/material.dart';
import 'package:agenda_ptval/modelo/estudiante_modelo.dart';
import 'package:agenda_ptval/modelo/clase_modelo.dart';
import 'package:agenda_ptval/controlador/estudiante_controller.dart';
import 'package:agenda_ptval/modelo/evento_historial.dart';
import 'package:crypto/crypto.dart';

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
  String correo = '';
  DateTime? fechaNacimiento;
  String gradoAprendizaje = 'texto'; // Valor predeterminado
  String? claseAsignada;
  String imagen = '';
  String contrasena = '';

  List<Clase> clases = []; // Lista para almacenar las clases

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

  void _registrar() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Estudiante nuevoEstudiante = Estudiante(
        nombre: nombre,
        apellidos: apellidos,
        correo: correo,
        fechaNacimiento: fechaNacimiento!,
        gradoAprendizaje: gradoAprendizaje,
        claseAsignada: claseAsignada!, // Guardamos el ID de la clase
        imagen: imagen,
        contrasena: hashPassword(contrasena),
        historial: [
          EventoHistorial(descripcion: 'Registrado en', fecha: DateTime.now()),
        ],
      );

      _controller.registrarEstudiante(nuevoEstudiante).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Estudiante registrado con éxito!')),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al registrar: $error')),
        );
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _cargarClases(); // Cargar clases al inicializar el estado
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro de Estudiante'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Nombre'),
                onSaved: (value) => nombre = value!,
                validator: (value) => value!.isEmpty ? 'Ingresa un nombre' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Apellidos'),
                onSaved: (value) => apellidos = value!,
                validator: (value) => value!.isEmpty ? 'Ingresa apellidos' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Correo'),
                onSaved: (value) => correo = value!,
                validator: (value) => value!.isEmpty ? 'Ingresa un correo' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Fecha de Nacimiento (YYYY-MM-DD)'),
                onSaved: (value) => fechaNacimiento = DateTime.parse(value!),
                validator: (value) => value!.isEmpty ? 'Ingresa la fecha de nacimiento' : null,
              ),
              DropdownButtonFormField<String>(
                value: gradoAprendizaje,
                decoration: InputDecoration(labelText: 'Grado de Aprendizaje'),
                items: ['texto', 'imagenes', 'videos'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    gradoAprendizaje = value!;
                  });
                },
              ),
              // Dropdown para seleccionar la clase
              DropdownButtonFormField<String>(
                value: claseAsignada,
                decoration: InputDecoration(labelText: 'Clase Asignada'),
                items: clases.map((Clase clase) {
                  return DropdownMenuItem<String>(
                    value: clase.nombre, // Aquí guardamos el ID de la clase
                    child: Text(clase.nombre), // Aquí mostramos el nombre de la clase
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    claseAsignada = value; // Aquí asignamos el ID de la clase seleccionada
                  });
                },
                validator: (value) => value == null ? 'Selecciona una clase' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'URL de Imagen'),
                onSaved: (value) => imagen = value!,
                validator: (value) => value!.isEmpty ? 'Ingresa una URL de imagen' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
                onSaved: (value) => contrasena = value!,
                validator: (value) => value!.isEmpty ? 'Ingresa una contraseña' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _registrar,
                child: Text('Registrar Estudiante'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
