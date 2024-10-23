// clase_modelo.dart
class Clase {
  String nombre;

  Clase({required this.nombre});

  // Método para convertir de Map a Clase
  factory Clase.fromMap(Map<String, dynamic> data) {
    return Clase(
      nombre: data['nombre'] ?? '',
    );
  }
}
