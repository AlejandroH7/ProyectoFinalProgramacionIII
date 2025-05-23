import 'package:fitmanager/presentation/pages/clientes_page.dart';
import 'package:fitmanager/presentation/pages/gestion_empleados_page.dart';
import 'package:fitmanager/presentation/pages/inventario_mantenimiento_page.dart';
import 'package:fitmanager/presentation/pages/membresias_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'select_user_page.dart';
import 'login_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A2A2A),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: _buildDrawer(context),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              // Logo y título
              Image.asset('assets/images/logo.png', height: 80),
              const SizedBox(height: 10),
              Text(
                'FIT MANAGER',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),

              // Botones de navegación
              _buildNavButton(
                icon: Icons.people,
                text: 'Gestión de clientes',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ClientesPage()),
                  );
                },
              ),
              const SizedBox(height: 15),
              _buildNavButton(
                icon: Icons.credit_card,
                text: 'Membresías y pagos',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MembresiasPage()),
                  );
                },
              ),
              const SizedBox(height: 15),
              _buildNavButton(
                icon: Icons.work,
                text: 'Gestión de empleados',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const GestionEmpleadosPage(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 15),
              _buildNavButton(
                icon: Icons.build,
                text: 'Inventario de equipos y mantenimiento',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const InventarioMantenimientoPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavButton({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
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
        onPressed: onTap,
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF2A2A2A),
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
        children: [
          ListTile(
            leading: const Icon(Icons.person, color: Colors.orange),
            title: Text(
              'Seleccionar usuario',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SelectUserPage()),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.logout, color: Colors.orange),
            title: Text(
              'Cerrar sesión',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
            onTap: () {
              _showLogoutDialog(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.home, color: Colors.orange),
            title: Text(
              'Volver al menú principal',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
            onTap: () {
              Navigator.pop(context); // Cierra el drawer
            },
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: const Color(0xFF2A2A2A),
            title: const Text(
              '¿Desea cerrar sesión?',
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Cierra el diálogo
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                    (route) => false,
                  );
                },
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFFFF9800),
                ),
                child: const Text('Sí', style: TextStyle(color: Colors.white)),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                style: TextButton.styleFrom(backgroundColor: Colors.blue),
                child: const Text('No', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
    );
  }
}
