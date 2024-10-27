// profesor_modelo.dart

/// Representa un profesor con varios atributos.
class Profesor {
  /// El ID del profesor en Firestore.
  final int idProfesor;

  /// El apodo del profesor.
  final String nickname;

  /// Indica si el profesor es administrador.
  final bool administrador;

  /// La contraseña del profesor.
  final String contrasena;

  /// Constructor para crear una instancia de [Profesor].
  /// 
  /// [idProfesor] es el ID del profesor.
  /// [nickname] es el apodo del profesor.
  /// [administrador] indica si el profesor es administrador.
  /// [contrasena] es la contraseña del profesor.
  Profesor({
    required this.idProfesor,
    required this.nickname,
    required this.administrador,
    required this.contrasena,
  });

  /// Método para crear una instancia de [Profesor] a partir de un mapa (por ejemplo, desde Firestore).
  /// 
  /// [map] es el mapa que contiene los datos del profesor.
  /// Devuelve una instancia de [Profesor].
  factory Profesor.fromMap(Map<String, dynamic> map) {
    return Profesor(
      idProfesor: map['id_profesor'] ?? 0,
      nickname: map['nickname'] ?? '',
      administrador: map['administrador'] ?? false,
      contrasena: map['contraseña'] ?? '',
    );
  }

  /// Método para convertir una instancia de [Profesor] a un mapa (para guardar en Firestore).
  /// 
  /// Devuelve un mapa que representa al profesor.
  Map<String, dynamic> toMap() {
    return {
      'id_profesor': idProfesor,
      'nickname': nickname,
      'administrador': administrador,
      'contraseña': contrasena,
    };
  }
}