// evento_historial.dart
class EventoHistorial {
  final String descripcion;
  final DateTime fecha;

  EventoHistorial({
    required this.descripcion,
    required this.fecha,
  });

  Map<String, dynamic> toJson() {
    return {
      'descripcion': descripcion,
      'fecha': fecha.toIso8601String(), // Convierte a String para almacenar
    };
  }

  static EventoHistorial fromJson(Map<String, dynamic> json) {
    return EventoHistorial(
      descripcion: json['descripcion'],
      fecha: DateTime.parse(json['fecha']),
    );
  }
}
