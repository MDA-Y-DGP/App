// clase_modelo.dart
class Clase {
  int idClase;
  String nombre;

  Clase({required this.idClase, required this.nombre});

  // Método para convertir de Map a Clase
  factory Clase.fromMap(Map<String, dynamic> data) {
    return Clase(
      idClase: data['id_clase'] ?? 0,
      nombre: data['nombre'] ?? '',
    );
  }

  // Método para convertir de Clase a Map
  Map<String, dynamic> toMap() {
    return {
      'id_clase': idClase,
      'nombre': nombre,
    };
  }
}