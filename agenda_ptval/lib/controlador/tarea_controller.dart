import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agenda_ptval/modelo/tarea_modelo.dart';
import 'package:intl/intl.dart';

class TareaController {
  final CollectionReference _tareasCollection =
      FirebaseFirestore.instance.collection('tareas');

  Future<void> crearTarea(Tarea tarea) async {
    // Obtener todas las tareas para encontrar el mayor ID
    QuerySnapshot querySnapshot = await _tareasCollection.get();
    int maxId = 0;

    for (var doc in querySnapshot.docs) {
      int currentId = doc['id'] as int;
      if (currentId > maxId) {
        maxId = currentId;
      }
    }

    // Asignar a la nueva tarea un ID que sea uno más que el mayor ID encontrado
    int newId = maxId + 1;

    // Crear la nueva tarea con el ID asignado
    Tarea nuevaTarea = Tarea(
      idTarea: newId,
      titulo: tarea.titulo,
      descripcion: tarea.descripcion,
    );

    // Guardar la nueva tarea en Firestore
    await _tareasCollection.doc(newId.toString()).set(nuevaTarea.toMap());
  }


}