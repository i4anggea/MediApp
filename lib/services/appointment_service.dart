import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/appointment_model.dart';

class AppointmentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Crear una nueva cita
  Future<bool> crearCita(AppointmentModel cita) async {
    try {
      await _firestore.collection('citas').add(cita.toMap());
      return true;
    } catch (e) {
      print('Error al crear cita: $e');
      return false;
    }
  }

  // Obtener citas del paciente
  Stream<List<AppointmentModel>> obtenerCitasPaciente(String pacienteId) {
    return _firestore
        .collection('citas')
        .where('pacienteId', isEqualTo: pacienteId)
        .orderBy('fecha', descending: false)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => AppointmentModel.fromMap(doc.data(), doc.id))
              .toList();
        });
  }

  // Obtener citas del doctor
  Stream<List<AppointmentModel>> obtenerCitasDoctor(String doctorId) {
    return _firestore
        .collection('citas')
        .where('doctorId', isEqualTo: doctorId)
        .orderBy('fecha', descending: false)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => AppointmentModel.fromMap(doc.data(), doc.id))
              .toList();
        });
  }

  Future<List<Map<String, dynamic>>> obtenerPacientesDeDoctor(
    String doctorId,
  ) async {
    try {
      final snapshot = await _firestore
          .collection('citas')
          .where('doctorId', isEqualTo: doctorId)
          .get();

      // Usar un Map para evitar duplicados por pacienteId
      final Map<String, Map<String, dynamic>> pacientesUnicos = {};

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final String pacienteId = data['pacienteId'] ?? '';
        final String pacienteNombre = data['pacienteNombre'] ?? '';

        if (pacienteId.isEmpty) continue;

        // Si quieres también email, puedes guardarlo en la cita o buscarlo después
        pacientesUnicos[pacienteId] = {
          'id': pacienteId,
          'nombre': pacienteNombre,
        };
      }

      return pacientesUnicos.values.toList();
    } catch (e) {
      print('Error al obtener pacientes del doctor: $e');
      return [];
    }
  }

  // Obtener lista de doctores
  Future<List<Map<String, dynamic>>> obtenerDoctores() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('usuarios')
          .where('tipo', isEqualTo: 'doctor')
          .get();

      return snapshot.docs.map((doc) {
        return {'id': doc.id, 'nombre': doc['nombre'], 'email': doc['email']};
      }).toList();
    } catch (e) {
      print('Error al obtener doctores: $e');
      return [];
    }
  }

  // Cancelar cita
  Future<bool> cancelarCita(String citaId) async {
    try {
      await _firestore.collection('citas').doc(citaId).update({
        'estado': 'cancelada',
      });
      return true;
    } catch (e) {
      print('Error al cancelar cita: $e');
      return false;
    }
  }
}
