import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../controlador/estudiante_controller.dart';
import '../controlador/imagen_controller.dart';
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
  late ImagenController _imagenController;
  List<Map<String, dynamic>> estudiantes = [];
  Map<String, dynamic>? estudianteSeleccionado;
  String pictogramaPassword = '';

  @override
  void initState() {
    super.initState();
    _estudianteController = EstudianteController();
    _imagenController = ImagenController();
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
      for (var estudiante in lista) {
        estudiante['foto'] = await _imagenController.obtenerFotoPerfil(estudiante['nickname']);
      }
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

  void _iniciarSesion() async {
    if (_formKey.currentState!.validate()) {
      String password = hashPassword(_passwordController.text);

      try {
        final estudiante = await _estudianteController.iniciarSesion(estudianteSeleccionado!['nickname'], password);

        if (estudiante != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Credenciales válidas')),
          );
        } else {
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

  Widget _buildPasswordForm() {
    if (estudianteSeleccionado == null) {
      return const SizedBox(); // Retorna un widget vacío si no hay estudiante seleccionado
    }

    String gradoAprendizaje = estudianteSeleccionado!['gradoAprendizaje'] ?? 'alto';

    return LayoutBuilder(
      builder: (context, constraints) {
        double widthFactor = constraints.maxWidth * 0.8;

        if (gradoAprendizaje == 'alto') {
          return Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: widthFactor),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
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
                ),
              ),
            ),
          );
        } else {
          return Center(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: widthFactor),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Hola, ${estudianteSeleccionado!['nickname']}!',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    const Text('Ingresa tu contraseña usando los pictogramas:'),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      children: List.generate(6, (index) {
                        int pictogramaNumero = index + 1;
                        return GestureDetector(
                          onTap: () => _agregarDigitoPictograma(pictogramaNumero),
                          child: Image.asset(
                            'assets/Sol.png',
                            width: 200,
                            height: 200,
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Secuencia: $pictogramaPassword',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _resetPictogramaPassword,
                      child: const Text('Borrar Secuencia'),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _iniciarSesionConPictograma,
                      child: const Text('Iniciar Sesión'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
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
            estudianteSeleccionado!['nickname'], constrasena);

        if (estudiante != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Credenciales válidas')),
          );
        } else {
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
              FutureBuilder<String>(
                future: _imagenController.obtenerFotoPerfil(estudiante['nickname']),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return const Icon(Icons.error);
                  } else if (snapshot.hasData) {
                    return CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(snapshot.data!),
                    );
                  } else {
                    return const Icon(Icons.error);
                  }
                },
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
                    child: FutureBuilder<String>(
                      future: _imagenController.obtenerFotoPerfil(estudianteSeleccionado!['nickname']),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return const Icon(Icons.error);
                        } else if (snapshot.hasData) {
                          return CircleAvatar(
                            radius: 80,
                            backgroundImage: NetworkImage(snapshot.data!),
                          );
                        } else {
                          return const Icon(Icons.error);
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildPasswordForm(),
                ],
              ),
      ),
    );
  }
}
