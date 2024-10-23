// estudiante_modelo.dart
import 'evento_historial.dart';

class Estudiante {
  String nombre;
  String apellidos;
  String correo;
  DateTime fechaNacimiento;
  String gradoAprendizaje; // Puede ser "texto", "imagenes", o "videos"
  String claseAsignada;
  String imagen;
  bool activo;
  String contrasena; // Asegúrate de manejarla de forma segura
  List<EventoHistorial> historial; // Lista para almacenar el historial

  Estudiante({
    required this.nombre,
    required this.apellidos,
    required this.correo,
    required this.fechaNacimiento,
    required this.gradoAprendizaje,
    required this.claseAsignada,
    required this.imagen,
    this.activo = true,
    required this.contrasena,
    List<EventoHistorial>? historial,
  }) : historial = historial ?? [];
}
