import 'package:flutter/material.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sobre la app')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.local_hospital, size: 40, color: Colors.blue),
                SizedBox(width: 12),
                Text(
                  'Telemedicina',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text('Versión 1.0.0', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 24),
            const Text(
              'Descripción',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Aplicación de telemedicina desarrollada como proyecto universitario. '
              'Permite a pacientes y doctores gestionar citas, realizar videollamadas '
              'y comunicarse por chat en tiempo real.',
            ),
            const SizedBox(height: 24),
            const Text(
              'Tecnologías utilizadas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              '• Flutter\n'
              '• Firebase Authentication\n'
              '• Cloud Firestore\n'
              '• Firebase Storage\n'
              '• Agora (videollamadas)',
            ),
            const SizedBox(height: 24),
            const Text(
              'Autor',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Nombre del estudiante\n'
              "Gea Torres Ian Xavier\n"
              "Hernandez Hernadez Gonzalo\n"
              "Universidad: Instituto Tecnologico de San Luis Potosi\n"
              "Carrera : Ing. Sistema Computacionales\n",
            ),
          ],
        ),
      ),
    );
  }
}
