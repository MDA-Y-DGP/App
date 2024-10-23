class Profesor {
  final String id; // ID del profesor en Firestore
  final String nombre;
  final String apellidos;
  final String email;
  final String? telefono; // Puede ser nulo
  final String? idClase; // Puede ser nulo
  final bool administrador;
  final String contrasena; // Contraseña del profesor

  Profesor({
    required this.id,
    required this.nombre,
    required this.apellidos,
    required this.email,
    this.telefono,
    this.idClase,
    required this.administrador,
    required this.contrasena,
  });

  // Método para crear un Profesor a partir de un mapa (por ejemplo, desde Firestore)
  factory Profesor.fromMap(Map<String, dynamic> map, String documentId) {
    return Profesor(
      id: documentId,
      nombre: map['nombre'] ?? '',
      apellidos: map['apellidos'] ?? '',
      email: map['email'] ?? '',
      telefono: map['telefono'],
      idClase: map['id_clase']?.toString(),
      administrador: map['administrador'] ?? false,
      contrasena: map['contraseña'] ?? '',
    );
  }

  // Método para convertir un Profesor a un mapa (para guardar en Firestore)
  Map<String, dynamic> toMap() {
    return {
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