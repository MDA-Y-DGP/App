// historial_modelo.dart

/// Representa un historial asociado a un estudiante.
class Historial {
  /// El ID del historial.
  int idHistorial;

  /// El ID del estudiante asociado a este historial.
  int idEstudiante;

  /// Un mapa que contiene las tareas del historial.
  /// Cada entrada en el mapa tiene una fecha y un array de nombres de tareas.
  Map<String, dynamic> tareas;

  /// Constructor para crear una instancia de [Historial].
  /// 
  /// [idHistorial] es el ID del historial.
  /// [idEstudiante] es el ID del estudiante asociado a este historial.
  /// [tareas] es un mapa que contiene las tareas del historial.
  Historial({
    required this.idHistorial,
    required this.idEstudiante,
    required this.tareas,
  });

  /// Método para convertir el objeto a un mapa (JSON).
  /// 
  /// Devuelve un mapa que representa el historial.
  Map<String, dynamic> toJson() {
    return {
      'id_historial': idHistorial,
      'id_estudiante': idEstudiante,
      'tareas': tareas,
    };
  }

  /// Método para crear un objeto [Historial] desde un mapa (JSON).
  /// 
  /// [json] es el mapa que contiene los datos del historial.
  /// Devuelve una instancia de [Historial].
  factory Historial.fromJson(Map<String, dynamic> json) {
    return Historial(
      idHistorial: json['id_historial'],
      idEstudiante: json['id_estudiante'],
      tareas: (json['tareas'] as Map<String, dynamic>),
    );
  }
}