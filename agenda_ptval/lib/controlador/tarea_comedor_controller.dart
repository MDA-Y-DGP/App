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
}