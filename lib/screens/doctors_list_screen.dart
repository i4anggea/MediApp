import 'package:flutter/material.dart';
import '../services/appointment_service.dart';

class DoctorsListScreen extends StatefulWidget {
  @override
  State<DoctorsListScreen> createState() => _DoctorsListScreenState();
}

class _DoctorsListScreenState extends State<DoctorsListScreen> {
  final AppointmentService _appointmentService = AppointmentService();
  bool _cargando = true;
  List<Map<String, dynamic>> _doctores = [];

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    final docs = await _appointmentService.obtenerDoctores();
    setState(() {
      _doctores = docs;
      _cargando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Doctores disponibles')),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : _doctores.isEmpty
          ? const Center(child: Text('No hay doctores registrados'))
          : ListView.builder(
              itemCount: _doctores.length,
              itemBuilder: (context, index) {
                final d = _doctores[index];
                return ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.person)),
                  title: Text('Dr. ${d['nombre']}'),
                  subtitle: Text(d['email']),
                  onTap: () {
                    // Aquí podrías ir directo a agendar cita con ese doctor
                    Navigator.pop(context, d);
                  },
                );
              },
            ),
    );
  }
}
