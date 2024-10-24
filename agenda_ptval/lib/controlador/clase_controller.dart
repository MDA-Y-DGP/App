import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agenda_ptval/modelo/clase_modelo.dart';

class ClaseController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Método para obtener todas las clases y encontrar el mayor ID
  Future<int> _obtenerMayorIdClase() async {
    QuerySnapshot snapshot = await _firestore.collection('clases').get();
    int maxId = 0;

    for (var doc in snapshot.docs) {
      int currentId = doc['id_clase'] as int;
      if (currentId > maxId) {
        maxId = currentId;
      }
    }

    return maxId;
  }

  // Método para agregar una nueva clase
  Future<void> agregarClase(Clase clase) async {
    try {
      // Obtener el mayor ID de las clases existentes
      int maxId = await _obtenerMayorIdClase();

      // Asignar a la nueva clase un ID que sea uno más que el mayor ID encontrado
      int newId = maxId + 1;

      // Crear un nuevo documento en la colección "clases" con el nuevo ID
      await _firestore.collection('clases').add({
        'id_clase': newId,
        'nombre': clase.nombre,
      });
    } catch (e) {
      throw Exception('Error al agregar clase: $e');
    }
  }

  // Método para obtener las clases
  Future<List<Clase>> obtenerClases() async {
    QuerySnapshot snapshot = await _firestore.collection('clases').get();
    return snapshot.docs.map((doc) => Clase.fromMap(doc.data() as Map<String, dynamic>)).toList();
  }
}