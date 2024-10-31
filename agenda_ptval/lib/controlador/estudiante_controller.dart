import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agenda_ptval/modelo/estudiante_modelo.dart';
import 'package:agenda_ptval/controlador/historial_controller.dart';
import 'package:agenda_ptval/modelo/historial_modelo.dart';

/// Controlador para manejar las operaciones relacionadas con los estudiantes.
class EstudianteController {
  /// Referencia a la colección de estudiantes en Firestore.
  final CollectionReference _estudiantesCollection = FirebaseFirestore.instance.collection('estudiantes');

  /// Instancia del controlador de historiales.
  final HistorialController _historialController = HistorialController();

  /// Registra un nuevo estudiante y crea un historial asociado.
  /// 
  /// [estudiante] es la instancia de [Estudiante] que se va a registrar.
  /// Asigna un nuevo ID al estudiante y al historial, y los guarda en la base de datos.
  Future<void> registrarEstudiante(Estudiante estudiante) async {
    // Verificar si el nickname ya existe
    QuerySnapshot existingNicknames = await _estudiantesCollection
        .where('nickname', isEqualTo: estudiante.nickname)
        .get();

    if (existingNicknames.docs.isNotEmpty) {
      throw Exception('El nickname ya está en uso.');
    }

    // Obtener todos los estudiantes para encontrar el mayor ID
    QuerySnapshot estudiantesSnapshot = await _estudiantesCollection.get();
    int maxEstudianteId = 0;

    for (var doc in estudiantesSnapshot.docs) {
      int currentId = doc['id_estudiante'] as int;
      if (currentId > maxEstudianteId) {
        maxEstudianteId = currentId;
      }
    }

    // Asignar al nuevo estudiante un ID que sea uno más que el mayor ID encontrado
    int newEstudianteId = maxEstudianteId + 1;

    // Obtener el mayor ID de los historiales
    int maxHistorialId = await _historialController.obtenerMayorIdHistorial();

    // Asignar al nuevo historial un ID que sea uno más que el mayor ID encontrado
    int newHistorialId = maxHistorialId + 1;

    // Crear un nuevo estudiante con el nuevo ID
    Estudiante nuevoEstudiante = Estudiante(
      idEstudiante: newEstudianteId,
      nickname: estudiante.nickname,
      gradoAprendizaje: estudiante.gradoAprendizaje,
      idClase: estudiante.idClase,
      idHistorial: newHistorialId,
      contrasena: estudiante.contrasena,
    );

    // Crear un nuevo historial asociado al estudiante
    Historial nuevoHistorial = Historial(
      idHistorial: newHistorialId,
      idEstudiante: newEstudianteId,
      tareas: {
        'fecha': DateTime.now(),
        'nombre': ['tarea 1'],
      },
    );

    // Añadir el nuevo estudiante y el nuevo historial a la base de datos
    await _estudiantesCollection.add(nuevoEstudiante.toJson());
    await _historialController.agregarHistorial(nuevoHistorial);
  }

  /// Inicia sesión de un estudiante verificando el `nickname` y la `contrasena`.
  /// Retorna una instancia de `Estudiante` si la autenticación es exitosa.
  Future<Estudiante?> iniciarSesion(String nickname, String contrasena) async {
    try {
      // Buscar al estudiante con el nickname y contraseña dados
      QuerySnapshot query = await _estudiantesCollection
          .where('nickname', isEqualTo: nickname)
          .where('contrasena', isEqualTo: contrasena)
          .get();

      if (query.docs.isEmpty) {
        // No se encontró un estudiante con ese nickname y contraseña
        return null;
      }

      // Convertir el primer resultado de la consulta a un objeto Estudiante
      var doc = query.docs.first;
      return Estudiante.fromJson(doc.data() as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Error al iniciar sesión: $e');
    }
  }

  /// Obtiene el nombre y el grado de aprendizaje de todos los estudiantes en la base de datos.
  Future<List<Map<String, dynamic>>> obtenerNombreGradoDeEstudiantes() async {
    try {
      QuerySnapshot querySnapshot = await _estudiantesCollection.get();

      List<Map<String, dynamic>> listaEstudiantes = [];

      for (var doc in querySnapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;

        listaEstudiantes.add({
          'nickname': data['nickname'],
          'gradoAprendizaje': data['grado_aprendizaje']
        });
      }

      return listaEstudiantes;
    } catch (e) {
      throw Exception('Error al obtener nombres y grados de estudiantes: $e');
    }
  }
}