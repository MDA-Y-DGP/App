import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agenda_ptval/modelo/menu_modelo.dart';

class MenusController {
  final CollectionReference _menusCollection =
      FirebaseFirestore.instance.collection('menus');

  Future<void> crearMenu(Menu menu) async {
    // Verificar si ya existe un menú con el mismo nombre
    QuerySnapshot existingMenuSnapshot = await _menusCollection
        .where('nombre', isEqualTo: menu.nombre)
        .get();

    if (existingMenuSnapshot.docs.isNotEmpty) {
      throw Exception('Ya existe un menú con este nombre');
    }

    // Obtener todos los menús para encontrar el mayor ID
    QuerySnapshot querySnapshot = await _menusCollection.get();
    int maxId = 0;

    for (var doc in querySnapshot.docs) {
      int currentId = doc['id_menu'] as int;
      if (currentId > maxId) {
        maxId = currentId;
      }
    }

    // Asignar al nuevo menú un ID que sea uno más que el mayor ID encontrado
    int newId = maxId + 1;

    // Crear el nuevo menú con el ID asignado
    Menu nuevoMenu = Menu(
      idMenu: newId,
      nombre: menu.nombre,
      descripcion: menu.descripcion,
    );

    // Guardar el nuevo menú en Firestore
    await _menusCollection.add(nuevoMenu.toMap());
  }

  Future<List<Menu>> obtenerTodosLosMenus() async {
    QuerySnapshot querySnapshot = await _menusCollection.get();
    return querySnapshot.docs.map((doc) {
      return Menu.fromMap(doc.data() as Map<String, dynamic>);
    }).toList();
  }
}