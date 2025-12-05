import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/user_model.dart';
import '../models/appointment_model.dart';
import '../services/appointment_service.dart';
import 'video_call_screen.dart';

class DoctorAppointmentsScreen extends StatelessWidget {
  final UserModel doctor;
  final AppointmentService _appointmentService = AppointmentService();

  DoctorAppointmentsScreen({required this.doctor});

  Color _getEstadoColor(String estado) {
    switch (estado) {
      case 'programada':
        return Colors.blue;
      case 'completada':
        return Colors.green;
      case 'cancelada':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Citas'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<List<AppointmentModel>>(
        stream: _appointmentService.obtenerCitasDoctor(doctor.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error al cargar citas: ${snapshot.error}'),
            );
          }

          final citas = snapshot.data ?? [];

          if (citas.isEmpty) {
            return const Center(
              child: Text(
                'No tienes citas agendadas',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: citas.length,
            itemBuilder: (context, index) {
              final cita = citas[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Paciente + estado
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              cita.pacienteNombre,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: _getEstadoColor(cita.estado),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              cita.estado.toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Fecha y hora
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            size: 20,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            DateFormat('dd/MM/yyyy').format(cita.fecha),
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(width: 16),
                          const Icon(
                            Icons.access_time,
                            size: 20,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            DateFormat('HH:mm').format(cita.fecha),
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),

                      // Motivo
                      if (cita.motivo != null && cita.motivo!.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        const Text(
                          'Motivo:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          cita.motivo!,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],

                      // Diagnóstico (si ya hay)
                      if (cita.diagnostico != null &&
                          cita.diagnostico!.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        const Text(
                          'Diagnóstico:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          cita.diagnostico!,
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],

                      const SizedBox(height: 12),

                      // Botones de acción
                      Row(
                        children: [
                          // Videollamada
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: cita.estado == 'cancelada'
                                  ? null
                                  : () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => VideoCallScreen(
                                            channelName: cita.id,
                                            userName: doctor.nombre,
                                          ),
                                        ),
                                      );
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                              ),
                              icon: const Icon(Icons.video_call),
                              label: const Text('Videollamada'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Marcar como completada (opcional)
                          if (cita.estado == 'programada')
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () async {
                                  // Aquí podrías crear un método en AppointmentService
                                  // para marcar la cita como completada y guardar diagnóstico.
                                  // Por ahora solo mostramos un mensaje.
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Aquí puedes implementar "marcar como completada"',
                                      ),
                                    ),
                                  );
                                },
                                child: const Text('Completar'),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
