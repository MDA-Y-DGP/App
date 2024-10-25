// profesor_modelo.dart

/// Representa un profesor con varios atributos.
class Profesor {
  /// El ID del profesor en Firestore.
  final int idProfesor;

  /// El nombre del profesor.
  final String nombre;

  /// Los apellidos del profesor.
  final String apellidos;

  /// El correo electrónico del profesor.
  final String email;

  /// El número de teléfono del profesor (puede ser nulo).
  final String? telefono;

  /// El ID de la clase a la que pertenece el profesor (puede ser nulo).
  final int? idClase;

  /// Indica si el profesor es administrador.
  final bool administrador;

  /// La contraseña del profesor.
  final String contrasena;

  /// Constructor para crear una instancia de [Profesor].
  /// 
  /// [idProfesor] es el ID del profesor.
  /// [nombre] es el nombre del profesor.
  /// [apellidos] son los apellidos del profesor.
  /// [email] es el correo electrónico del profesor.
  /// [telefono] es el número de teléfono del profesor (puede ser nulo).
  /// [idClase] es el ID de la clase a la que pertenece el profesor (puede ser nulo).
  /// [administrador] indica si el profesor es administrador.
  /// [contrasena] es la contraseña del profesor.
  Profesor({
    required this.idProfesor,
    required this.nombre,
    required this.apellidos,
    required this.email,
    this.telefono,
    this.idClase,
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
      nombre: map['nombre'] ?? '',
      apellidos: map['apellidos'] ?? '',
      email: map['email'] ?? '',
      telefono: map['telefono'],
      idClase: map['id_clase'] != null ? map['id_clase'] as int : null,
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
      'nombre': nombre,
      'apellidos': apellidos,
      'email': email,
      'telefono': telefono,
      'id_clase': idClase,
      'administrador': administrador,
      'contraseña': contrasena,
    };
  }
}