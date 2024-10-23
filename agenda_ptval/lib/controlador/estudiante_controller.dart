// estudiante_controller.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agenda_ptval/modelo/estudiante_modelo.dart';
import 'package:agenda_ptval/modelo/evento_historial.dart';

class EstudianteController {
  final CollectionReference _estudiantesCollection = FirebaseFirestore.instance.collection('estudiantes');

  Future<void> registrarEstudiante(Estudiante estudiante) async {
    // Convertir el historial a una lista de mapas
    List<Map<String, dynamic>> historialJson = estudiante.historial.map((evento) => evento.toJson()).toList();

    // Crear un nuevo estudiante con un historial inicial
    await _estudiantesCollection.add({
      'nombre': estudiante.nombre,
      'apellidos': estudiante.apellidos,
      'correo': estudiante.correo,
      'fecha_nacimiento': estudiante.fechaNacimiento,
      'grado_aprendizaje': estudiante.gradoAprendizaje,
      'clase_asignada': estudiante.claseAsignada,
      'imagen': estudiante.imagen,
      'activo': estudiante.activo,
      'contrasena': estudiante.contrasena, // Asegúrate de cifrar la contraseña
      'historial': historialJson, // Agregar el historial
    });
  }

  // Método para agregar un evento al historial
  Future<void> agregarEventoHistorial(String estudianteId, EventoHistorial evento) async {
    await _estudiantesCollection.doc(estudianteId).update({
      'historial': FieldValue.arrayUnion([evento.toJson()]),
    });
  }

  // Método para obtener el historial
  Future<List<EventoHistorial>> obtenerHistorial(String estudianteId) async {
    DocumentSnapshot doc = await _estudiantesCollection.doc(estudianteId).get();
    List<dynamic> historialJson = doc['historial'];
    return historialJson.map((evento) => EventoHistorial.fromJson(evento)).toList();
  }
}
