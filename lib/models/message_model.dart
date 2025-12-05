import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String id;
  final String texto;
  final String remitenteId;
  final String remitenteNombre;
  final DateTime timestamp;
  final String tipo;
  final String? urlImagen;

  MessageModel({
    required this.id,
    required this.texto,
    required this.remitenteId,
    required this.remitenteNombre,
    required this.timestamp,
    this.tipo = 'texto',
    this.urlImagen,
  });

  factory MessageModel.fromMap(Map<String, dynamic> map, String id) {
    return MessageModel(
      id: id,
      texto: map['texto'] ?? '',
      remitenteId: map['remitenteId'] ?? '',
      remitenteNombre: map['remitenteNombre'] ?? '',
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      tipo: map['tipo'] ?? 'texto',
      urlImagen: map['urlImagen'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'texto': texto,
      'remitenteId': remitenteId,
      'remitenteNombre': remitenteNombre,
      'timestamp': Timestamp.fromDate(timestamp),
      'tipo': tipo,
      'urlImagen': urlImagen,
    };
  }
}
