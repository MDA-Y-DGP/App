import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agenda_ptval/modelo/tarea_comedor_modelo.dart';

class TareaComedorController {
  final CollectionReference _tareasComedorCollection =
      FirebaseFirestore.instance.collection('tareasComedor');

  Future<void> crearTareaComedor(TareaComedor tareaComedor) async {
    // Obtener todas las tareas de comedor para encontrar el mayor ID
    QuerySnapshot querySnapshot = await _tareasComedorCollection.get();
    int maxId = 0;

    for (var doc in querySnapshot.docs) {
      int currentId = doc['idTareaComedor'] as int;
      if (currentId > maxId) {
        maxId = currentId;
      }
    }

    // Asignar a la nueva tarea de comedor un ID que sea uno más que el mayor ID encontrado
    int newId = maxId + 1;

    // Crear la nueva tarea de comedor con el ID asignado
    TareaComedor nuevaTareaComedor = TareaComedor(
      idTareaComedor: newId,
      titulo: tareaComedor.titulo,
      fecha: DateTime.now(),
    );

    // Guardar la nueva tarea de comedor en Firestore
    await _tareasComedorCollection.doc(newId.toString()).set(nuevaTareaComedor.toMap());
  }

  /// Obtiene todas las tareas de comedor.
  Future<List<QueryDocumentSnapshot>> fetchTareasComedor() async {
    QuerySnapshot snapshot = await _tareasComedorCollection.get();
    return snapshot.docs;
  }

  /// Asigna una tarea de comedor a una lista de alumnos.
  Future<void> asignarTareas(String tareaId, List<String> alumnosIds) async {
    try {
      for (String alumnoId in alumnosIds) {
        await FirebaseFirestore.instance.collection('alumnos').doc(alumnoId).collection('tareasComedor').add({
          'tareaId': tareaId,
          'fecha': DateTime.now(),
          'descripcion': 'Tarea de comedor asignada',
        });
      }
    } catch (e) {
      throw Exception('Error al asignar tarea: $e');
    }
  }
}