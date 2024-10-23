import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agenda_ptval/modelo/clase_modelo.dart';

class ClaseController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> agregarClase(Clase clase) async {
    try {
      // Crear un nuevo documento en la colección "clases"
      await _firestore.collection('clases').add({
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
