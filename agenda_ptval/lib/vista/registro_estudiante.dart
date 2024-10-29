import 'dart:convert';
import 'dart:io';
import 'package:agenda_ptval/controlador/clase_controller.dart';
import 'package:flutter/material.dart';
import 'package:agenda_ptval/modelo/estudiante_modelo.dart';
import 'package:agenda_ptval/modelo/clase_modelo.dart';
import 'package:agenda_ptval/controlador/estudiante_controller.dart';
import 'package:crypto/crypto.dart';
import 'package:image_picker/image_picker.dart';

class RegistroEstudiante extends StatefulWidget {
  @override
  _RegistroEstudianteState createState() => _RegistroEstudianteState();
}

class _RegistroEstudianteState extends State<RegistroEstudiante> {
  final _formKey = GlobalKey<FormState>();
  final EstudianteController _controller = EstudianteController();
  final ClaseController _claseController = ClaseController();
  final ImagePicker _picker = ImagePicker();

  String nickname = '';
  String gradoAprendizaje = 'bajo'; // Valor predeterminado
  String? claseAsignada;
  File? imagen;
  String contrasena = '';
  String foto = '';

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

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          imagen = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al seleccionar la imagen: $e')),
      );
    }
  }

  Future<void> _registrar() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Estudiante nuevoEstudiante = Estudiante(
        idEstudiante: 0, // Este valor se actualizará en el controlador
        nickname: nickname,
        gradoAprendizaje: gradoAprendizaje,
        idClase: int.parse(claseAsignada!), // Guardamos el ID de la clase
        idHistorial: 0, // Este valor se actualizará en el controlador
        contrasena: hashPassword(contrasena),
        foto: foto,
      );

      try {
        await _controller.registrarEstudiante(nuevoEstudiante);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Estudiante registrado con éxito!')),
        );
        Navigator.pop(context); // Volver a la página anterior
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al registrar: $e')),
        );
      }
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
        border: const OutlineInputBorder(),
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
        border: const OutlineInputBorder(),
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
      decoration: const InputDecoration(
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
        title: const Text('Registro de Estudiante'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextFormField(
                labelText: 'Nickname',
                onSaved: (value) => nickname = value!,
                validator: (value) => value!.isEmpty ? 'Ingresa un nickname' : null,
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
              ListTile(
                title: Text(imagen == null ? 'Selecciona una imagen (opcional)' : 'Imagen seleccionada'),
                trailing: const Icon(Icons.image),
                onTap: _pickImage,
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
                onPressed: () async {
                  try {
                    await _registrar();
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(e.toString())),
                    );
                  }
                },
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