import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/user_model.dart';
import '../models/appointment_model.dart';
import '../services/appointment_service.dart';

class CreateAppointmentScreen extends StatefulWidget {
  final UserModel usuario;

  CreateAppointmentScreen({required this.usuario});

  @override
  _CreateAppointmentScreenState createState() =>
      _CreateAppointmentScreenState();
}

class _CreateAppointmentScreenState extends State<CreateAppointmentScreen> {
  final AppointmentService _appointmentService = AppointmentService();
  final TextEditingController _motivoController = TextEditingController();

  List<Map<String, dynamic>> _doctores = [];
  Map<String, dynamic>? _doctorSeleccionado;
  DateTime _fechaSeleccionada = DateTime.now().add(Duration(days: 1));
  TimeOfDay _horaSeleccionada = TimeOfDay(hour: 9, minute: 0);
  bool _cargando = false;

  @override
  void initState() {
    super.initState();
    _cargarDoctores();
  }

  Future<void> _cargarDoctores() async {
    List<Map<String, dynamic>> doctores = await _appointmentService
        .obtenerDoctores();
    setState(() {
      _doctores = doctores;
      if (_doctores.isNotEmpty) {
        _doctorSeleccionado = _doctores[0];
      }
    });
  }

  Future<void> _seleccionarFecha() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _fechaSeleccionada,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 90)),
    );

    if (picked != null && picked != _fechaSeleccionada) {
      setState(() {
        _fechaSeleccionada = picked;
      });
    }
  }

  Future<void> _seleccionarHora() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _horaSeleccionada,
    );

    if (picked != null && picked != _horaSeleccionada) {
      setState(() {
        _horaSeleccionada = picked;
      });
    }
  }

  Future<void> _agendarCita() async {
    if (_doctorSeleccionado == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Selecciona un doctor')));
      return;
    }

    if (_motivoController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ingresa el motivo de la consulta')),
      );
      return;
    }

    setState(() => _cargando = true);

    // Combinar fecha y hora
    DateTime fechaHora = DateTime(
      _fechaSeleccionada.year,
      _fechaSeleccionada.month,
      _fechaSeleccionada.day,
      _horaSeleccionada.hour,
      _horaSeleccionada.minute,
    );

    AppointmentModel nuevaCita = AppointmentModel(
      id: '',
      pacienteId: widget.usuario.id,
      pacienteNombre: widget.usuario.nombre,
      doctorId: _doctorSeleccionado!['id'],
      doctorNombre: _doctorSeleccionado!['nombre'],
      fecha: fechaHora,
      estado: 'programada',
      motivo: _motivoController.text,
    );

    bool exitoso = await _appointmentService.crearCita(nuevaCita);

    setState(() => _cargando = false);

    if (exitoso) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cita agendada exitosamente'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al agendar cita'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agendar Cita'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: _cargando
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Seleccionar Doctor',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: _doctores.isEmpty
                        ? Padding(
                            padding: EdgeInsets.all(16),
                            child: Text('No hay doctores disponibles'),
                          )
                        : DropdownButton<Map<String, dynamic>>(
                            isExpanded: true,
                            value: _doctorSeleccionado,
                            underline: SizedBox(),
                            items: _doctores.map((doctor) {
                              return DropdownMenuItem(
                                value: doctor,
                                child: Text('Dr. ${doctor['nombre']}'),
                              );
                            }).toList(),
                            onChanged: (valor) {
                              setState(() {
                                _doctorSeleccionado = valor;
                              });
                            },
                          ),
                  ),
                  SizedBox(height: 24),

                  Text(
                    'Fecha de la Cita',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  InkWell(
                    onTap: _seleccionarFecha,
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today, color: Colors.blue),
                          SizedBox(width: 12),
                          Text(
                            DateFormat('dd/MM/yyyy').format(_fechaSeleccionada),
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24),

                  Text(
                    'Hora de la Cita',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  InkWell(
                    onTap: _seleccionarHora,
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.access_time, color: Colors.blue),
                          SizedBox(width: 12),
                          Text(
                            _horaSeleccionada.format(context),
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24),

                  Text(
                    'Motivo de la Consulta',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    controller: _motivoController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Describe el motivo de tu consulta...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  SizedBox(height: 32),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _agendarCita,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      child: Text(
                        'Agendar Cita',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
