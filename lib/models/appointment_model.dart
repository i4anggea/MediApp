import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentModel {
  final String id;
  final String pacienteId;
  final String pacienteNombre;
  final String doctorId;
  final String doctorNombre;
  final DateTime fecha;
  final String estado;
  final String? motivo;
  final String? diagnostico;

  AppointmentModel({
    required this.id,
    required this.pacienteId,
    required this.pacienteNombre,
    required this.doctorId,
    required this.doctorNombre,
    required this.fecha,
    required this.estado,
    this.motivo,
    this.diagnostico,
  });

  factory AppointmentModel.fromMap(Map<String, dynamic> map, String id) {
    return AppointmentModel(
      id: id,
      pacienteId: map['pacienteId'] ?? '',
      pacienteNombre: map['pacienteNombre'] ?? '',
      doctorId: map['doctorId'] ?? '',
      doctorNombre: map['doctorNombre'] ?? '',
      fecha: (map['fecha'] as Timestamp).toDate(),
      estado: map['estado'] ?? 'programada',
      motivo: map['motivo'],
      diagnostico: map['diagnostico'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'pacienteId': pacienteId,
      'pacienteNombre': pacienteNombre,
      'doctorId': doctorId,
      'doctorNombre': doctorNombre,
      'fecha': Timestamp.fromDate(fecha),
      'estado': estado,
      'motivo': motivo,
      'diagnostico': diagnostico,
    };
  }
}
