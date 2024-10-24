// profesor_modelo.dart
class Profesor {
  final int idProfesor; // ID del profesor en Firestore
  final String nombre;
  final String apellidos;
  final String email;
  final String? telefono; // Puede ser nulo
  final int? idClase; // Puede ser nulo y es un número
  final bool administrador;
  final String contrasena; // Contraseña del profesor

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

  // Método para crear un Profesor a partir de un mapa (por ejemplo, desde Firestore)
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

  // Método para convertir un Profesor a un mapa (para guardar en Firestore)
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