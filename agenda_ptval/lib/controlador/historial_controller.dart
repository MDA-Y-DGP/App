// historial_controller.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agenda_ptval/modelo/historial_modelo.dart';

class HistorialController {
  final CollectionReference _historialCollection = FirebaseFirestore.instance.collection('historiales');

  // Método para obtener el mayor ID de los historiales
  Future<int> obtenerMayorIdHistorial() async {
    QuerySnapshot snapshot = await _historialCollection.get();
    int maxId = 0;

    for (var doc in snapshot.docs) {
      int currentId = doc['id_historial'] as int;
      if (currentId > maxId) {
        maxId = currentId;
      }
    }

    return maxId;
  }

  // Método para agregar un nuevo historial
  Future<void> agregarHistorial(Historial historial) async {
    await _historialCollection.add(historial.toJson());
  }

  // Método para obtener el historial de un estudiante
  Future<Historial?> obtenerHistorialPorEstudiante(int idEstudiante) async {
    QuerySnapshot snapshot = await _historialCollection.where('id_estudiante', isEqualTo: idEstudiante).get();
    if (snapshot.docs.isNotEmpty) {
      return Historial.fromJson(snapshot.docs.first.data() as Map<String, dynamic>);
    }
    return null;
  }
}