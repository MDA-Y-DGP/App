// estudiante_modelo.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Estudiante {
  int idEstudiante;
  String nombre;
  String apellidos;
  String correo;
  DateTime fechaNacimiento;
  String gradoAprendizaje; // Puede ser "texto", "imagenes", o "videos"
  int idClase;
  int idHistorial;
  String contrasena; // Asegúrate de manejarla de forma segura

  Estudiante({
    required this.idEstudiante,
    required this.nombre,
    required this.apellidos,
    required this.correo,
    required this.fechaNacimiento,
    required this.gradoAprendizaje,
    required this.idClase,
    required this.idHistorial,
    required this.contrasena,
  });

  // Método para convertir el objeto a un mapa (JSON)
  Map<String, dynamic> toJson() {
    return {
      'id_estudiante': idEstudiante,
      'nombre': nombre,
      'apellidos': apellidos,
      'correo': correo,
      'fecha_nacimiento': fechaNacimiento,
      'grado_aprendizaje': gradoAprendizaje,
      'id_clase': idClase,
      'id_historial': idHistorial,
      'contrasena': contrasena,
    };
  }

  // Método para crear un objeto Estudiante desde un mapa (JSON)
  factory Estudiante.fromJson(Map<String, dynamic> json) {
    return Estudiante(
      idEstudiante: json['id_estudiante'],
      nombre: json['nombre'],
      apellidos: json['apellidos'],
      correo: json['correo'],
      fechaNacimiento: (json['fecha_nacimiento'] as Timestamp).toDate(),
      gradoAprendizaje: json['grado_aprendizaje'],
      idClase: json['id_clase'],
      idHistorial: json['id_historial'],
      contrasena: json['contrasena'],
    );
  }
}