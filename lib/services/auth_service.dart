import "package:firebase_auth/firebase_auth.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import '../models/user_model.dart';

class AuthService {
  get _auth => FirebaseAuth.instance;

  get _firestore => FirebaseFirestore.instance;

  User? get usuarioActual => _auth.currentUser;

  Future<UserModel?> registrar({
    required String email,
    required String password,
    required String nombre,
    required String tipo,
  }) async {
    try {
      UserCredential resultado = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      UserModel nuevoUsuario = UserModel(
        id: resultado.user!.uid,
        email: email,
        nombre: nombre,
        tipo: tipo,
      );

      await _firestore
          .collection('usuarios')
          .doc(resultado.user!.uid)
          .set(nuevoUsuario.toMap());

      return nuevoUsuario;
    } catch (e) {
      print('Error al registrar: $e');
      return null;
    }
  }

  Future<UserModel?> iniciarSesion({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential resultado = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      DocumentSnapshot doc = await _firestore
          .collection('usuarios')
          .doc(resultado.user!.uid)
          .get();

      return UserModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    } catch (e) {
      print('Error al iniciar sesión: $e');
      return null;
    }
  }

  Future<void> cerrarSesion() async {
    await _auth.signOut();
  }
}
