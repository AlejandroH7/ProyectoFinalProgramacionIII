import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fitmanager/data/models/empleado_model.dart';
import 'package:fitmanager/data/repositories/empleado_repository.dart';
import 'package:intl/intl.dart';

class HorariosTurnosPage extends StatelessWidget {
  const HorariosTurnosPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ahora = TimeOfDay.now();

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
      body: FutureBuilder<List<Empleado>>(
        future: EmpleadoRepository().obtenerEmpleados(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No hay empleados registrados.',
                style: TextStyle(color: Colors.white70),
              ),
            );
          }

          final empleados =
              snapshot.data!..sort(
                (a, b) => _safeParseTime(
                  a.horaEntrada,
                ).compareTo(_safeParseTime(b.horaEntrada)),
              );

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            itemCount: empleados.length,
            itemBuilder: (context, index) {
              final emp = empleados[index];
              final entrada = _safeParseTime(emp.horaEntrada);
              final salida = _safeParseTime(emp.horaSalida);
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
                    emp.nombre,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(
                    'Turno: ${emp.horaEntrada} a ${emp.horaSalida}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  TimeOfDay _safeParseTime(String time) {
    try {
      final clean = time.trim(); // limpia espacios
      final parsed = DateFormat.jm().parse(clean); // "8:00 AM"
      return TimeOfDay.fromDateTime(parsed);
    } catch (e) {
      debugPrint("❌ Error al parsear hora '$time': $e");
      return const TimeOfDay(hour: 0, minute: 0); // valor por defecto
    }
  }

  bool _estaEnTurno(TimeOfDay actual, TimeOfDay entrada, TimeOfDay salida) {
    final minutosActual = actual.hour * 60 + actual.minute;
    final minutosEntrada = entrada.hour * 60 + entrada.minute;
    final minutosSalida = salida.hour * 60 + salida.minute;
    return minutosActual >= minutosEntrada && minutosActual <= minutosSalida;
  }
}
