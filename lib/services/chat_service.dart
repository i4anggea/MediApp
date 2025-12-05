import "package:cloud_firestore/cloud_firestore.dart";
import '../models/message_model.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Generar ID de chat entre dos usuarios
  String generarChatId(String userId1, String userId2) {
    List<String> ids = [userId1, userId2];
    ids.sort();
    return '${ids[0]}_${ids[1]}';
  }

  // Enviar mensaje
  Future<bool> enviarMensaje({
    required String chatId,
    required String texto,
    required String remitenteId,
    required String remitenteNombre,
  }) async {
    try {
      MessageModel mensaje = MessageModel(
        id: '',
        texto: texto,
        remitenteId: remitenteId,
        remitenteNombre: remitenteNombre,
        timestamp: DateTime.now(),
      );

      await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('mensajes')
          .add(mensaje.toMap());

      // Actualizar último mensaje en el chat
      await _firestore.collection('chats').doc(chatId).set({
        'ultimoMensaje': texto,
        'timestamp': Timestamp.now(),
        'participantes': [remitenteId],
      }, SetOptions(merge: true));

      return true;
    } catch (e) {
      print('Error al enviar mensaje: $e');
      return false;
    }
  }

  // Obtener mensajes del chat
  Stream<List<MessageModel>> obtenerMensajes(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('mensajes')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => MessageModel.fromMap(doc.data(), doc.id))
              .toList();
        });
  }

  // Obtener lista de chats del usuario
  Future<List<Map<String, dynamic>>> obtenerChatsUsuario(String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('chats')
          .where('participantes', arrayContains: userId)
          .orderBy('timestamp', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        return {
          'chatId': doc.id,
          'ultimoMensaje': doc['ultimoMensaje'] ?? '',
          'timestamp': doc['timestamp'],
        };
      }).toList();
    } catch (e) {
      print('Error al obtener chats: $e');
      return [];
    }
  }
}
