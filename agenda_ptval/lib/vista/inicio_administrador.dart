import 'package:flutter/material.dart';
import '../modelo/profesor_modelo.dart';

class PantallaInicioAdministrador extends StatelessWidget {
  final Profesor profesor;

  const PantallaInicioAdministrador({super.key, required this.profesor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Has iniciado sesión, ${profesor.nombre}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text('Nombre: ${profesor.nombre}', style: const TextStyle(fontSize: 16)),
            Text('Apellidos: ${profesor.apellidos}', style: const TextStyle(fontSize: 16)),
            Text('Email: ${profesor.email}', style: const TextStyle(fontSize: 16)),
            Text('Teléfono: ${profesor.telefono ?? "No disponible"}', style: const TextStyle(fontSize: 16)),
            Text('ID Clase: ${profesor.idClase ?? "No disponible"}', style: const TextStyle(fontSize: 16)),
            Text('Administrador: ${profesor.administrador ? "Sí" : "No"}', style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}