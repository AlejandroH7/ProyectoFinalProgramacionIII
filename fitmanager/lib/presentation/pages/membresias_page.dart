import 'package:fitmanager/presentation/pages/clientes_por_vencer_page.dart';
import 'package:fitmanager/presentation/pages/generar_recibo_page.dart';
import 'package:fitmanager/presentation/pages/realizar_pago_page.dart';
import 'package:fitmanager/presentation/pages/registro_pagos_cliente_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MembresiasPage extends StatelessWidget {
  const MembresiasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A2A2A),
        title: Row(
          children: [
            const Icon(Icons.payments, color: Colors.white),
            const SizedBox(width: 10),
            Text(
              'Membresías y pagos',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          ],
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildMainButton(
              icon: Icons.attach_money,
              text: 'Realizar pago de membresía',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RealizarPagoPage()),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildMainButton(
              icon: Icons.history,
              text: 'Registro de pagos por cliente',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const RegistroPagosClientePage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildMainButton(
              icon: Icons.warning_amber,
              text: 'Clientes con membresía por vencer',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ClientesPorVencerPage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildMainButton(
              icon: Icons.receipt,
              text: 'Generación de recibos digitales',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const GenerarReciboPage()),
                );
              },
            ),
            const Spacer(),
            _buildSecondaryButton(
              icon: Icons.arrow_back,
              text: 'Volver',
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainButton({
    required IconData icon,
    required String text,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white),
      label: Text(
        text,
        style: const TextStyle(fontSize: 16, color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFF9800),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
    );
  }

  Widget _buildSecondaryButton({
    required IconData icon,
    required String text,
    required VoidCallback onPressed,
  }) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white),
      label: Text(text, style: const TextStyle(color: Colors.white)),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
        side: const BorderSide(color: Colors.white),
      ),
    );
  }
}
