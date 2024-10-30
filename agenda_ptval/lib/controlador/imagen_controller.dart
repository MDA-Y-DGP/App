import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class ImagenController {
  Future<String> subirImagen(File imagen, String nombre) async {
    try {
      final storageRef = FirebaseStorage.instance.ref().child('img_perfil/$nombre');
      final uploadTask = storageRef.putFile(imagen);
      final snapshot = await uploadTask.whenComplete(() => null);
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception('Error al subir la imagen: $e');
    }
  }
}