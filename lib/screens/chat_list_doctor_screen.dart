import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/appointment_service.dart';
import 'chat_screen.dart';

class ChatsListDoctorScreen extends StatefulWidget {
  final UserModel doctor;

  const ChatsListDoctorScreen({super.key, required this.doctor});

  @override
  State<ChatsListDoctorScreen> createState() => _ChatsListDoctorScreenState();
}

class _ChatsListDoctorScreenState extends State<ChatsListDoctorScreen> {
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
      appBar: AppBar(title: const Text('Mensajes')),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : _pacientes.isEmpty
          ? const Center(
              child: Text(
                'No tienes pacientes con los que chatear aún.',
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
                  subtitle: const Text('Toca para chatear'),
                  trailing: const Icon(Icons.chat),
                  onTap: () {
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
