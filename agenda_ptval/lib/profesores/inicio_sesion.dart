import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'profesor.dart';
import 'inicio.dart';

class InicioSesion extends StatefulWidget {
  final FirebaseFirestore firestore;

  const InicioSesion({super.key, required this.firestore});

  @override
  _InicioSesionState createState() => _InicioSesionState();
}

class _InicioSesionState extends State<InicioSesion> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Método para iniciar sesión
  void _iniciarSesion() async {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text;
      String password = _passwordController.text;

      try {
        // Verificar las credenciales en Firestore
        final QuerySnapshot result = await widget.firestore
            .collection('profesores')
            .where('email', isEqualTo: email)
            .where('contraseña', isEqualTo: password)
            .get();

        if (result.docs.isNotEmpty) {
          // Credenciales válidas, crear objeto Profesor
          final doc = result.docs.first;
          final profesor = Profesor.fromMap(doc.data() as Map<String, dynamic>, doc.id);

          // Navegar a la nueva pantalla
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => PantallaInicio(profesor: profesor),
            ),
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

  // Widget para el fondo de pantalla
  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/background.jpg'), // Asegúrate de tener esta imagen en tu carpeta assets
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  // Widget para el logo y el título
  Widget _buildLogo() {
    return Column(
      children: [
        Image.asset('assets/profesor.png', height: 250), 
        const SizedBox(height: 20),
        const Text(
          'Inicio de Sesión - Profesor',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  // Widget para el formulario de inicio de sesión
  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildEmailField(),
          const SizedBox(height: 16),
          _buildPasswordField(),
          const SizedBox(height: 20),
          _buildLoginButton(),
        ],
      ),
    );
  }

  // Widget para el campo de correo electrónico
  Widget _buildEmailField() {
    return Semantics(
      label: 'Campo de correo electrónico',
      hint: 'Ingresa tu correo electrónico',
      child: TextFormField(
        controller: _emailController,
        decoration: InputDecoration(
          labelText: 'Correo Electrónico',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          filled: true,
          fillColor: Colors.white.withOpacity(0.8),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor ingresa tu correo electrónico';
          } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
            return 'Ingresa un correo electrónico válido';
          }
          return null;
        },
      ),
    );
  }

  // Widget para el campo de contraseña
  Widget _buildPasswordField() {
    return Semantics(
      label: 'Campo de contraseña',
      hint: 'Ingresa tu contraseña',
      child: TextFormField(
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
    );
  }

  // Widget para el botón de inicio de sesión
  Widget _buildLoginButton() {
    return Semantics(
      label: 'Botón de inicio de sesión',
      hint: 'Presiona para iniciar sesión',
      child: ElevatedButton(
        onPressed: _iniciarSesion,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Text('Iniciar Sesión'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Semantics(
          label: 'Botón de atrás',
          hint: 'Vuelve a la página anterior',
          child: IconButton(
            icon: const Icon(Icons.arrow_back, size: 30), 
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          _buildBackground(),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Semantics(
                    label: 'Logo de la aplicación',
                    child: _buildLogo(),
                  ),
                  const SizedBox(height: 40),
                  Semantics(
                    label: 'Formulario de inicio de sesión',
                    child: _buildForm(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}