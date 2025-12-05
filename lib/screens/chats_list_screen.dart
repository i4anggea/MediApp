import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/appointment_service.dart';
import 'chat_screen.dart';

class ChatsListScreen extends StatefulWidget {
  final UserModel usuario;

  ChatsListScreen({required this.usuario});

  @override
  _ChatsListScreenState createState() => _ChatsListScreenState();
}

class _ChatsListScreenState extends State<ChatsListScreen> {
  final AppointmentService _appointmentService = AppointmentService();
  List<Map<String, dynamic>> _contactos = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarContactos();
  }

  Future<void> _cargarContactos() async {
    if (widget.usuario.tipo == 'paciente') {
      // Para pacientes: mostrar lista de doctores
      List<Map<String, dynamic>> doctores = await _appointmentService
          .obtenerDoctores();
      setState(() {
        _contactos = doctores;
        _cargando = false;
      });
    } else {
      // Para doctores: podrías cargar lista de pacientes
      // Por ahora mostraremos mensaje
      setState(() {
        _cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mensajes'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: _cargando
          ? Center(child: CircularProgressIndicator())
          : _contactos.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.chat_bubble_outline, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No hay conversaciones',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: _contactos.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> contacto = _contactos[index];

                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  title: Text(
                    'Dr. ${contacto['nombre']}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(contacto['email']),
                  trailing: Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatScreen(
                          usuarioActual: widget.usuario,
                          otroUsuarioId: contacto['id'],
                          otroUsuarioNombre: contacto['nombre'],
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
