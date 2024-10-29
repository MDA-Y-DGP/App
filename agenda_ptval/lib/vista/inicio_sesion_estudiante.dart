import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../controlador/estudiante_controller.dart';
import 'package:crypto/crypto.dart';

class InicioSesionEstudiante extends StatefulWidget {
  final FirebaseFirestore firestore;

  const InicioSesionEstudiante({super.key, required this.firestore});

  @override
  _InicioSesionEstudianteState createState() => _InicioSesionEstudianteState();
}

class _InicioSesionEstudianteState extends State<InicioSesionEstudiante> {
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late EstudianteController _estudianteController;
  List<Map<String, dynamic>> estudiantes = [];
  Map<String, dynamic>? estudianteSeleccionado;
  String pictogramaPassword = '';

  @override
  void initState() {
    super.initState();
    _estudianteController = EstudianteController();
    _cargarEstudiantes();
  }

  String hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<void> _cargarEstudiantes() async {
    try {
      List<Map<String, dynamic>> lista = await _estudianteController.obtenerNombreFotoGradoDeEstudiantes();
      setState(() {
        estudiantes = lista;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar estudiantes: $e')),
      );
    }
  }

  void _seleccionarEstudiante(Map<String, dynamic> estudiante) {
    setState(() {
      estudianteSeleccionado = estudiante;
    });
  }

  // Método para iniciar sesión
  void _iniciarSesion() async {
    if (_formKey.currentState!.validate()) {
      String password = hashPassword(_passwordController.text);

      try {
        // Verificar las credenciales en Firestore
        final estudiante = await _estudianteController.iniciarSesion(estudianteSeleccionado!['nickname']!, password);

        if (estudiante != null) {
          // Credenciales válidas
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Credenciales válidas')),
          );
        } else {
          // Credenciales inválidas
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Credenciales inválidas')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error inesperado: $e')),
        );
      }
    }
  }

  // Método para construir el formulario de contraseña
  Widget _buildPasswordForm() {
    if (estudianteSeleccionado == null) {
      return const SizedBox(); // Retorna un widget vacío si no hay estudiante seleccionado
    }

    // Obtener el grado de aprendizaje del estudiante seleccionado
    String gradoAprendizaje = estudianteSeleccionado!['gradoAprendizaje'] ?? 'alto';

    if (gradoAprendizaje == 'alto') {
      // Campo de texto normal para grado alto
      return Form(
        key: _formKey,
        child: Column(
          children: [
            Text(
              'Hola, ${estudianteSeleccionado!['nickname']}!',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Contraseña',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.white.withOpacity(0.8),
              ),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa tu contraseña';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _iniciarSesion,
              child: const Text('Iniciar Sesión'),
            ),
          ],
        ),
      );
    } else {
      // Mostrar pictogramas para grado medio o bajo
      return Column(
        children: [
          Text(
            'Hola, ${estudianteSeleccionado!['nickname']}!',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text('Ingresa tu contraseña usando los pictogramas:'),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            children: List.generate(6, (index) {
              int pictogramaNumero = index + 1;
              return GestureDetector(
                onTap: () => _agregarDigitoPictograma(pictogramaNumero),
                child: Image.asset(
                  'agenda_ptval/assets/Sol.png',
                  width: 60,
                  height: 60,
                ),
              );
            }),
          ),
          const SizedBox(height: 10),
          Text(
            'Secuencia: $pictogramaPassword',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _resetPictogramaPassword,
            child: Text('Borrar Secuencia'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _iniciarSesionConPictograma,
            child: const Text('Iniciar Sesión'),
          ),
        ],
      );
    }
  }

  void _agregarDigitoPictograma(int digito) {
    if (pictogramaPassword.length < 4) {
      setState(() {
        pictogramaPassword += digito.toString();
      });
    }
  }

  void _resetPictogramaPassword() {
    setState(() {
      pictogramaPassword = '';
    });
  }

  void _iniciarSesionConPictograma() async {
    if (pictogramaPassword.length == 4) {

      String constrasena = hashPassword(pictogramaPassword);

      try {
        final estudiante = await _estudianteController.iniciarSesion(
            estudianteSeleccionado!['nickname']!, constrasena);

        if (estudiante != null) {
          // Credenciales válidas
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Credenciales válidas')),
          );
        } else {
          // Credenciales inválidas
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Credenciales inválidas')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error inesperado: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debes seleccionar 4 pictogramas')),
      );
    }
  }

  // Muestra todas las fotos con nombres debajo
  Widget _buildStudentGrid() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.75,
      ),
      itemCount: estudiantes.length,
      itemBuilder: (context, index) {
        final estudiante = estudiantes[index];
        return GestureDetector(
          onTap: () => _seleccionarEstudiante(estudiante),
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: estudiante['foto'] != ''
                    ? NetworkImage(estudiante['foto']!)
                    : const AssetImage('assets/default_photo.png') as ImageProvider,
              ),
              const SizedBox(height: 8),
              Text(estudiante['nickname']!, style: const TextStyle(fontSize: 16)),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio de Sesión - Estudiante'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: estudianteSeleccionado == null
            ? _buildStudentGrid()
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => setState(() => estudianteSeleccionado = null),
              child: CircleAvatar(
                radius: 100,
                backgroundImage: estudianteSeleccionado!['foto'] != ''
                    ? NetworkImage(estudianteSeleccionado!['foto']!)
                    : const AssetImage('assets/default_photo.png') as ImageProvider,
              ),
            ),
            const SizedBox(height: 20),
            _buildPasswordForm(),
          ],
        ),
      ),
    );
  }
}
