class Tarea {
  final int idTarea;
  final String titulo;
  final String descripcion;

  Tarea({
    required this.idTarea,
    required this.titulo,
    required this.descripcion,
  });

  Map<String, dynamic> toMap() {
    return {
      'idTarea': idTarea,
      'titulo': titulo,
      'descripcion': descripcion,
    };
  }
}