import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificaciones = true;
  bool _modoOscuro = false;
  String _idioma = 'es';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configuración')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Notificaciones'),
            subtitle: const Text('Activar o desactivar notificaciones'),
            value: _notificaciones,
            onChanged: (valor) {
              setState(() => _notificaciones = valor);
            },
          ),
          SwitchListTile(
            title: const Text('Modo oscuro'),
            subtitle: const Text('Tema oscuro para la aplicación'),
            value: _modoOscuro,
            onChanged: (valor) {
              setState(() => _modoOscuro = valor);
              // Aquí podrías integrar un ThemeProvider para cambiar el tema global.
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Idioma'),
            subtitle: Text(_idioma == 'es' ? 'Español' : 'Inglés'),
            trailing: DropdownButton<String>(
              value: _idioma,
              items: const [
                DropdownMenuItem(value: 'es', child: Text('Español')),
                DropdownMenuItem(value: 'en', child: Text('Inglés')),
              ],
              onChanged: (valor) {
                if (valor == null) return;
                setState(() => _idioma = valor);
              },
            ),
          ),
        ],
      ),
    );
  }
}
