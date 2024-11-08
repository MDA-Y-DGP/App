class Menu {
  final int idMenu;
  final String nombre;
  final String descripcion;

  Menu({
    required this.idMenu,
    required this.nombre,
    required this.descripcion,
  });

  Map<String, dynamic> toMap() {
    return {
      'id_menu': idMenu,
      'nombre': nombre,
      'descripcion': descripcion,
    };
  }

  factory Menu.fromMap(Map<String, dynamic> map) {
    return Menu(
      idMenu: map['id_menu'],
      nombre: map['nombre'],
      descripcion: map['descripcion'],
    );
  }
}