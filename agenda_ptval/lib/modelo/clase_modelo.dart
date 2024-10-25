// clase_modelo.dart
/// Modelo que representa una clase del colegio en la base de datos.
class Clase {
  /// El ID de la clase.
  int idClase;

  /// El nombre de la clase.
  String nombre;

  /// Constructor para crear una instancia de [Clase].
  /// 
  /// [idClase] es el ID de la clase.
  /// [nombre] es el nombre de la clase.
  Clase({required this.idClase, required this.nombre});

  /// Método para crear una instancia de [Clase] a partir de un mapa (desde Firestore).
  /// 
  /// [data] es el mapa que contiene los datos de la clase.
  /// Devuelve una instancia de [Clase].
  factory Clase.fromMap(Map<String, dynamic> data) {
    return Clase(
      idClase: data['id_clase'] ?? 0,
      nombre: data['nombre'] ?? '',
    );
  }

  /// Método para convertir una instancia de [Clase] a un mapa (para guardar en Firestore).
  /// 
  /// Devuelve un mapa que representa la clase.
  Map<String, dynamic> toMap() {
    return {
      'id_clase': idClase,
      'nombre': nombre,
    };
  }
}