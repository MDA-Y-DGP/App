// historial_modelo.dart
class Historial {
  int idHistorial;
  int idEstudiante;
  Map<String, dynamic> tareas;

  Historial({
    required this.idHistorial,
    required this.idEstudiante,
    required this.tareas,
  });

  // Método para convertir el objeto a un mapa (JSON)
  Map<String, dynamic> toJson() {
    return {
      'id_historial': idHistorial,
      'id_estudiante': idEstudiante,
      'tareas': tareas,
    };
  }

  // Método para crear un objeto Historial desde un mapa (JSON)
  factory Historial.fromJson(Map<String, dynamic> json) {
    return Historial(
      idHistorial: json['id_historial'],
      idEstudiante: json['id_estudiante'],
      tareas: (json['tareas'] as Map<String, dynamic>),
    );
  }
}