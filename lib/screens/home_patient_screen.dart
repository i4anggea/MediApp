import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';
import 'appointments_screen.dart';
import 'chats_list_screen.dart';
import 'doctors_list_screen.dart';
import 'profile_screen.dart';

class HomePacienteScreen extends StatelessWidget {
  final UserModel usuario;
  final AuthService _authService = AuthService();

  HomePacienteScreen({super.key, required this.usuario});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inicio - Paciente'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await _authService.cerrarSesion();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            color: Colors.blue.shade50,
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.blue,
                  child: Icon(Icons.person, size: 50, color: Colors.white),
                ),
                SizedBox(height: 10),
                Text(
                  'Bienvenido, ${usuario.nombre}',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  usuario.email,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                ),
              ],
            ),
          ),

          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: EdgeInsets.all(16),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                _buildOpcion(
                  context,
                  'Mis Citas',
                  Icons.calendar_today,
                  Colors.blue,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AppointmentsScreen(usuario: usuario),
                      ),
                    );
                  },
                ),

                _buildOpcion(
                  context,
                  'Buscar Doctor',
                  Icons.search,
                  Colors.green,
                  () async {
                    final seleccionado = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => DoctorsListScreen()),
                    );

                    if (seleccionado != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Seleccionaste al Dr. ${seleccionado['nombre']}',
                          ),
                        ),
                      );
                      // Aquí podrías abrir directamente CreateAppointmentScreen con ese doctor.
                    }
                  },
                ),
                _buildOpcion(
                  context,
                  'Mensajes',
                  Icons.chat,
                  Colors.orange,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatsListScreen(usuario: usuario),
                      ),
                    );
                  },
                ),
                _buildOpcion(
                  context,
                  'Mi Perfil',
                  Icons.person,
                  Colors.purple,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProfileScreen(usuario: usuario),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOpcion(
    BuildContext context,
    String titulo,
    IconData icono,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icono, size: 48, color: color),
            SizedBox(height: 12),
            Text(
              titulo,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
