import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/user_model.dart';
import '../models/appointment_model.dart';
import '../services/appointment_service.dart';
import 'create_appointment_screen.dart';
import 'video_call_screen.dart';

class AppointmentsScreen extends StatelessWidget {
  final UserModel usuario;
  final AppointmentService _appointmentService = AppointmentService();

  AppointmentsScreen({required this.usuario});

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
        title: Text('Mis Citas'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<List<AppointmentModel>>(
        stream: usuario.tipo == 'paciente'
            ? _appointmentService.obtenerCitasPaciente(usuario.id)
            : _appointmentService.obtenerCitasDoctor(usuario.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error al cargar citas: ${snapshot.error}'),
            );
          }

          List<AppointmentModel> citas = snapshot.data ?? [];

          if (citas.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.calendar_today, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No tienes citas agendadas',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  if (usuario.tipo == 'paciente') ...[
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                CreateAppointmentScreen(usuario: usuario),
                          ),
                        );
                      },
                      child: Text('Agendar Cita'),
                    ),
                  ],
                ],
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: citas.length,
            itemBuilder: (context, index) {
              AppointmentModel cita = citas[index];

              return Card(
                margin: EdgeInsets.only(bottom: 16),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              usuario.tipo == 'paciente'
                                  ? 'Dr. ${cita.doctorNombre}'
                                  : cita.pacienteNombre,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: _getEstadoColor(cita.estado),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              cita.estado.toUpperCase(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 20,
                            color: Colors.grey,
                          ),
                          SizedBox(width: 8),
                          Text(
                            DateFormat('dd/MM/yyyy').format(cita.fecha),
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(width: 16),
                          Icon(Icons.access_time, size: 20, color: Colors.grey),
                          SizedBox(width: 8),
                          Text(
                            DateFormat('HH:mm').format(cita.fecha),
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      if (cita.motivo != null) ...[
                        SizedBox(height: 12),
                        Text(
                          'Motivo:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          cita.motivo!,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                      if (cita.estado == 'programada' &&
                          usuario.tipo == 'paciente') ...[
                        SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              bool? confirmar = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Cancelar Cita'),
                                  content: Text(
                                    '¿Estás seguro de cancelar esta cita?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: Text('No'),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                      child: Text('Sí, cancelar'),
                                    ),
                                    if (cita.estado == 'programada') ...[
                                      SizedBox(height: 8),
                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton.icon(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => VideoCallScreen(
                                                  channelName: cita.id,
                                                  userName: usuario.nombre,
                                                ),
                                              ),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green,
                                            foregroundColor: Colors.white,
                                          ),
                                          icon: Icon(Icons.video_call),
                                          label: Text('Iniciar Videollamada'),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              );

                              if (confirmar == true) {
                                bool exitoso = await _appointmentService
                                    .cancelarCita(cita.id);
                                if (exitoso) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Cita cancelada'),
                                      backgroundColor: Colors.orange,
                                    ),
                                  );
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                            child: Text('Cancelar Cita'),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: usuario.tipo == 'paciente'
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CreateAppointmentScreen(usuario: usuario),
                  ),
                );
              },
              backgroundColor: Colors.blue,
              child: Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }
}
