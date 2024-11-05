class TareaComedor {
  final int idTareaComedor;
  final String titulo;
  final DateTime fecha;

  TareaComedor({
    required this.idTareaComedor,
    required this.titulo,
    required this.fecha,
  });

  Map<String, dynamic> toMap() {
    return {
      'idTareaComedor': idTareaComedor,
      'titulo': titulo,
      'fecha': fecha.toIso8601String(), // Convertir la fecha a una cadena ISO 8601
    };
  }
}