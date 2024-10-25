// profesor_controlador.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agenda_ptval/modelo/profesor_modelo.dart';

/// Controlador para manejar las operaciones relacionadas con los profesores.
class ProfesorController {
  /// Referencia a la colección de profesores en Firestore.
  final CollectionReference _profesoresCollection = FirebaseFirestore.instance.collection('profesores');

  /// Método para registrar un nuevo profesor.
  /// 
  /// [profesor] es la instancia de [Profesor] que se va a registrar.
  /// Asigna un nuevo ID al profesor y lo guarda en la base de datos.
  Future<void> registrarProfesor(Profesor profesor) async {
    // Obtener todos los profesores para encontrar el mayor ID
    QuerySnapshot querySnapshot = await _profesoresCollection.get();
    int maxId = 0;

    for (var doc in querySnapshot.docs) {
      int currentId = doc['id_profesor'] as int;
      if (currentId > maxId) {
        maxId = currentId;
      }
    }

    // Asignar al nuevo profesor un ID que sea uno más que el mayor ID encontrado
    int newId = maxId + 1;

    // Crear un nuevo profesor con el nuevo ID
    Profesor nuevoProfesor = Profesor(
      idProfesor: newId,
      nombre: profesor.nombre,
      apellidos: profesor.apellidos,
      email: profesor.email,
      telefono: profesor.telefono,
      idClase: profesor.idClase,
      administrador: profesor.administrador,
      contrasena: profesor.contrasena,
    );

    // Añadir el nuevo profesor a la base de datos
    await _profesoresCollection.add(nuevoProfesor.toMap());
  }

  /// Método para obtener un profesor por ID.
  /// 
  /// [id] es el ID del profesor que se va a obtener.
  /// Devuelve una instancia de [Profesor] si se encuentra, de lo contrario, devuelve null.
  Future<Profesor?> obtenerProfesorPorId(String id) async {
    DocumentSnapshot doc = await _profesoresCollection.doc(id).get();
    if (doc.exists) {
      return Profesor.fromMap(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  /// Método para obtener todos los profesores.
  /// 
  /// Devuelve una lista de instancias de [Profesor].
  Future<List<Profesor>> obtenerTodosLosProfesores() async {
    QuerySnapshot querySnapshot = await _profesoresCollection.get();
    return querySnapshot.docs
        .map((doc) => Profesor.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  /// Método para verificar las credenciales del profesor.
  /// 
  /// [email] es el correo electrónico del profesor.
  /// [contrasena] es la contraseña del profesor.
  /// Devuelve una instancia de [Profesor] si las credenciales son correctas, de lo contrario, devuelve null.
  Future<Profesor?> verificarCredenciales(String email, String contrasena) async {
    final QuerySnapshot result = await _profesoresCollection
        .where('email', isEqualTo: email)
        .where('contraseña', isEqualTo: contrasena)
        .get();

    if (result.docs.isNotEmpty) {
      final doc = result.docs.first;
      return Profesor.fromMap(doc.data() as Map<String, dynamic>);
    }
    return null;
  }
}