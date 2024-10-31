// estudiante_modelo.dart

/// Representa un estudiante con varios atributos.
class Estudiante {
  /// El ID del estudiante.
  int idEstudiante;

  /// El apodo del estudiante.
  String nickname;

  /// El grado de aprendizaje del estudiante (puede ser "bajo", "medio" o "alto").
  String gradoAprendizaje;

  /// El ID de la clase a la que pertenece el estudiante.
  int idClase;

  /// El ID del historial del estudiante.
  int idHistorial;

  /// La contraseña del estudiante. Si el estudiante tiene un grado alto podrá usar texto en la contraseña, sino pictogramas.
  String contrasena;

  /// Constructor para crear una instancia de [Estudiante].
  /// 
  /// [idEstudiante] es el ID del estudiante.
  /// [nickname] es el apodo del estudiante.
  /// [gradoAprendizaje] es el grado de aprendizaje del estudiante.
  /// [idClase] es el ID de la clase a la que pertenece el estudiante.
  /// [idHistorial] es el ID del historial del estudiante.
  /// [contrasena] es la contraseña del estudiante.
  Estudiante({
    required this.idEstudiante,
    required this.nickname,
      required this.gradoAprendizaje,
    required this.idClase,
    required this.idHistorial,
    required this.contrasena,
  });

  /// Método para convertir el objeto a un mapa (JSON).
  /// 
  /// Devuelve un mapa que representa al estudiante.
  Map<String, dynamic> toJson() {
    return {
      'id_estudiante': idEstudiante,
      'nickname': nickname,
      'grado_aprendizaje': gradoAprendizaje,
      'id_clase': idClase,
      'id_historial': idHistorial,
      'contrasena': contrasena,
    };
  }

  /// Método para crear un objeto [Estudiante] desde un mapa (JSON).
  /// 
  /// [json] es el mapa que contiene los datos del estudiante.
  /// Devuelve una instancia de [Estudiante].
  factory Estudiante.fromJson(Map<String, dynamic> json) {
    return Estudiante(
      idEstudiante: json['id_estudiante'],
      nickname: json['nickname'],
      gradoAprendizaje: json['grado_aprendizaje'],
      idClase: json['id_clase'],
      idHistorial: json['id_historial'],
      contrasena: json['contrasena'],
    );
  }
}