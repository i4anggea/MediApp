import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';
import 'edit_profile_screen.dart';
import 'settings_screen.dart';
import 'about_app_screen.dart';

class ProfileScreen extends StatelessWidget {
  final UserModel usuario;
  final AuthService _authService = AuthService();

  ProfileScreen({required this.usuario});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mi perfil')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 40,
                  child: Icon(Icons.person, size: 40),
                ),
                const SizedBox(height: 12),
                Text(
                  usuario.nombre,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  usuario.email,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                ),
                const SizedBox(height: 8),
                Chip(
                  label: Text(
                    usuario.tipo == 'paciente' ? 'Paciente' : 'Doctor',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 8),

          // Opción: Editar perfil (a futuro)
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Editar perfil'),
            subtitle: const Text('Cambiar nombre, foto, datos básicos'),
            onTap: () async {
              final resultado = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditProfileScreen(usuario: usuario),
                ),
              );

              if (resultado != null && resultado is Map) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Datos actualizados, vuelve a ingresar para ver cambios.',
                    ),
                  ),
                );
              }
            },
          ),
          // Opción: Configuración (a futuro)
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Configuración'),
            subtitle: const Text('Notificaciones, idioma, tema'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
          // Opción: Sobre la app
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('Acerca de la aplicación'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AboutAppScreen()),
              );
            },
          ),

          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 8),

          // Cerrar sesión
          ElevatedButton.icon(
            onPressed: () async {
              await _authService.cerrarSesion();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => LoginScreen()),
                (route) => false,
              );
            },
            icon: const Icon(Icons.logout),
            label: const Text('Cerrar sesión'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
