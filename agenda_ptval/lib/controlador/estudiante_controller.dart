// estudiante_controller.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agenda_ptval/modelo/estudiante_modelo.dart';
import 'package:agenda_ptval/controlador/historial_controller.dart';
import 'package:agenda_ptval/modelo/historial_modelo.dart';

class EstudianteController {
  final CollectionReference _estudiantesCollection = FirebaseFirestore.instance.collection('estudiantes');
  final HistorialController _historialController = HistorialController();

  Future<void> registrarEstudiante(Estudiante estudiante) async {
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
      nombre: estudiante.nombre,
      apellidos: estudiante.apellidos,
      correo: estudiante.correo,
      fechaNacimiento: estudiante.fechaNacimiento,
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
}