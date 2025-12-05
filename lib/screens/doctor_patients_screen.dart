import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/appointment_service.dart';
import 'chat_screen.dart';

class DoctorPatientsScreen extends StatefulWidget {
  final UserModel doctor;

  const DoctorPatientsScreen({super.key, required this.doctor});

  @override
  State<DoctorPatientsScreen> createState() => _DoctorPatientsScreenState();
}

class _DoctorPatientsScreenState extends State<DoctorPatientsScreen> {
  final AppointmentService _appointmentService = AppointmentService();
  bool _cargando = true;
  List<Map<String, dynamic>> _pacientes = [];

  @override
  void initState() {
    super.initState();
    _cargarPacientes();
  }

  Future<void> _cargarPacientes() async {
    final lista = await _appointmentService.obtenerPacientesDeDoctor(
      widget.doctor.id,
    );
    setState(() {
      _pacientes = lista;
      _cargando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis pacientes')),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : _pacientes.isEmpty
          ? const Center(
              child: Text(
                'Aún no tienes pacientes con citas.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: _pacientes.length,
              itemBuilder: (context, index) {
                final p = _pacientes[index];
                return ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.person)),
                  title: Text(p['nombre'] ?? 'Paciente'),
                  subtitle: Text(p['id']),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // Abrir chat con este paciente
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatScreen(
                          usuarioActual: widget.doctor,
                          otroUsuarioId: p['id'],
                          otroUsuarioNombre: p['nombre'] ?? 'Paciente',
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
