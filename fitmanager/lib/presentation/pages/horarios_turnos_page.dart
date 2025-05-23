import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HorariosTurnosPage extends StatelessWidget {
  const HorariosTurnosPage({super.key});

  // Lista simulada de empleados y horarios
  final List<Map<String, dynamic>> empleados = const [
    {'nombre': 'Alejandro', 'entrada': '09:00', 'salida': '11:30'},
    {'nombre': 'María', 'entrada': '08:00', 'salida': '12:00'},
    {'nombre': 'Luis', 'entrada': '14:00', 'salida': '18:00'},
    {'nombre': 'Carlos', 'entrada': '11:00', 'salida': '13:00'},
  ];

  @override
  Widget build(BuildContext context) {
    final ahora = TimeOfDay.now();

    // Ordenar empleados por hora de entrada
    final empleadosOrdenados = [...empleados]..sort(
      (a, b) => _horaToTimeOfDay(
        a['entrada'],
      ).hour.compareTo(_horaToTimeOfDay(b['entrada']).hour),
    );

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A2A2A),
        title: Text(
          'Horarios de turnos',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: ListView.builder(
          itemCount: empleadosOrdenados.length,
          itemBuilder: (context, index) {
            final emp = empleadosOrdenados[index];
            final entrada = _horaToTimeOfDay(emp['entrada']);
            final salida = _horaToTimeOfDay(emp['salida']);
            final enTurno = _estaEnTurno(ahora, entrada, salida);

            return Card(
              color: const Color(0xFF2A2A2A),
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: Icon(
                  Icons.circle,
                  color: enTurno ? Colors.green : Colors.grey,
                  size: 14,
                ),
                title: Text(
                  emp['nombre'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  'Turno: ${emp['entrada']} a ${emp['salida']}',
                  style: const TextStyle(color: Colors.white70),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  TimeOfDay _horaToTimeOfDay(String hora) {
    final partes = hora.split(':');
    return TimeOfDay(hour: int.parse(partes[0]), minute: int.parse(partes[1]));
  }

  bool _estaEnTurno(TimeOfDay actual, TimeOfDay entrada, TimeOfDay salida) {
    final minutosActual = actual.hour * 60 + actual.minute;
    final minutosEntrada = entrada.hour * 60 + entrada.minute;
    final minutosSalida = salida.hour * 60 + salida.minute;
    return minutosActual >= minutosEntrada && minutosActual <= minutosSalida;
  }
}
