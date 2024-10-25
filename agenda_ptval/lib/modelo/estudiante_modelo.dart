// estudiante_modelo.dart
import 'package:cloud_firestore/cloud_firestore.dart';

/// Representa un estudiante con varios atributos.
class Estudiante {
  /// El ID del estudiante.
  int idEstudiante;

  /// El nombre del estudiante.
  String nombre;

  /// Los apellidos del estudiante.
  String apellidos;

  /// La fecha de nacimiento del estudiante.
  DateTime fechaNacimiento;

  /// El grado de aprendizaje del estudiante (puede ser "bajo", "medio" o "alto").
  String gradoAprendizaje;

  /// El ID de la clase a la que pertenece el estudiante.
  int idClase;

  /// El ID del historial del estudiante.
  int idHistorial;

  /// La contraseña del estudiante. Si el estudiante tiene un grado alto podra usar texto en la contraseña sino pictogramas.
  String contrasena;

  /// Constructor para crear una instancia de [Estudiante].
  /// 
  /// [idEstudiante] es el ID del estudiante.
  /// [nombre] es el nombre del estudiante.
  /// [apellidos] son los apellidos del estudiante.
  /// [correo] es el correo electrónico del estudiante.
  /// [fechaNacimiento] es la fecha de nacimiento del estudiante.
  /// [gradoAprendizaje] es el grado de aprendizaje del estudiante.
  /// [idClase] es el ID de la clase a la que pertenece el estudiante.
  /// [idHistorial] es el ID del historial del estudiante.
  /// [contrasena] es la contraseña del estudiante.
  Estudiante({
    required this.idEstudiante,
    required this.nombre,
    required this.apellidos,
    required this.fechaNacimiento,
    required this.gradoAprendizaje,
    required this.idClase,
    required this.idHistorial,
    required this.contrasena,
  });

  /// Método para convertir el objeto a un mapa (JSON).
  /// 
  /// Devuelve un mapa que representa al estudiante.
  Map<String, dynamic> toJson() {
    return {
      'id_estudiante': idEstudiante,
      'nombre': nombre,
      'apellidos': apellidos,
      'fecha_nacimiento': fechaNacimiento,
      'grado_aprendizaje': gradoAprendizaje,
      'id_clase': idClase,
      'id_historial': idHistorial,
      'contrasena': contrasena,
    };
  }

  /// Método para crear un objeto [Estudiante] desde un mapa (JSON).
  /// 
  /// [json] es el mapa que contiene los datos del estudiante.
  /// Devuelve una instancia de [Estudiante].
  factory Estudiante.fromJson(Map<String, dynamic> json) {
    return Estudiante(
      idEstudiante: json['id_estudiante'],
      nombre: json['nombre'],
      apellidos: json['apellidos'],
      fechaNacimiento: (json['fecha_nacimiento'] as Timestamp).toDate(),
      gradoAprendizaje: json['grado_aprendizaje'],
      idClase: json['id_clase'],
      idHistorial: json['id_historial'],
      contrasena: json['contrasena'],
    );
  }
}