# MediApp 🩺

**Prototipo universitario de telemedicina con Flutter, Firebase y Agora.**

MediApp reúne la gestión de citas y la comunicación entre pacientes y médicos en una aplicación móvil. El proyecto explora autenticación, persistencia de información y comunicación en tiempo real.

## Funcionalidades del prototipo

- Registro e inicio de sesión con perfiles de paciente y médico.
- Consulta, creación y cancelación de citas.
- Chat con mensajes almacenados en Cloud Firestore.
- Integración de videollamadas con Agora.
- Pantallas de consulta y edición de perfiles.

Estas funciones están representadas en el código. Su ejecución requiere configurar los servicios externos y validar los flujos en dispositivos.

## Tecnologías

| Área | Herramientas |
| --- | --- |
| Aplicación | Flutter y Dart |
| Autenticación | Firebase Authentication |
| Base de datos | Cloud Firestore |
| Videollamadas | Agora RTC |
| Permisos del dispositivo | permission_handler |

## Estructura

```text
lib/
├── main.dart          # Inicialización y entrada de la aplicación
├── models/            # Usuarios, citas y mensajes
├── screens/           # Pantallas y flujos de navegación
└── services/          # Autenticación, citas y chat
test/                  # Pruebas
android/               # Configuración de Android
ios/                   # Configuración de iOS
```

## Ejecución local

### Requisitos

- Flutter con una versión de Dart compatible con `^3.10.1`, según `pubspec.yaml`.
- Herramientas de desarrollo de Android o iOS y un dispositivo o emulador compatible.
- Firebase CLI y FlutterFire CLI instaladas, y acceso a un proyecto Firebase propio.
- Un proyecto Agora para configurar las videollamadas.

### 1. Descargar e instalar dependencias

```bash
git clone https://github.com/i4anggea/MediApp.git
cd MediApp
flutter pub get
```

### 2. Configurar Firebase

Inicia sesión con Firebase CLI y configura tu propio proyecto desde la raíz del repositorio:

```bash
firebase login
flutterfire configure
```

Selecciona las plataformas que utilizarás. La configuración debe generar `lib/firebase_options.dart`, importado por `main.dart`, y los archivos de plataforma correspondientes. El repositorio contiene referencias a la configuración original; reemplázalas por las de tu proyecto.

Habilita el proveedor de correo y contraseña en Firebase Authentication y configura Cloud Firestore. Define las reglas de acceso para tus usuarios y los índices que requieran las consultas de citas y chats. Estos pasos requieren configuración adicional a los comandos anteriores.

### 3. Configurar Agora

Reemplaza el valor de `appId` en `lib/screens/video_call_screen.dart` por el de tu proyecto. La implementación actual envía un token vacío al unirse al canal; si tu proyecto exige tokens, deberás integrar su obtención antes de probar las llamadas.

Verifica los permisos de cámara y micrófono de la plataforma elegida.

### 4. Iniciar la aplicación

```bash
flutter devices
flutter run
```

Para recorrer los flujos de demostración, utiliza cuentas y datos ficticios de paciente y médico. Las llamadas requieren que ambos participantes se unan al mismo canal.

## Estado y próximos pasos

Proyecto académico en evolución. La instalación y los flujos completos todavía necesitan una validación reproducible en un entorno configurado.

- [ ] Publicar capturas reales de las pantallas y un video del flujo principal.
- [ ] Sustituir la prueba del contador de Flutter por pruebas de autenticación y citas.
- [ ] Incorporar análisis estático y pruebas a GitHub Actions.
- [ ] Documentar reglas, índices y configuración de los servicios.
- [ ] Desarrollar MediApp Analytics como proyecto complementario con datos sintéticos de citas.

## Autor y portafolio

[Ian Gea · GitHub](https://github.com/i4anggea)
