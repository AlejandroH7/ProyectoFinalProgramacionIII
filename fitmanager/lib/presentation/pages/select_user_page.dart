import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_page.dart';

class SelectUserPage extends StatefulWidget {
  const SelectUserPage({super.key});

  @override
  State<SelectUserPage> createState() => _SelectUserPageState();
}

class _SelectUserPageState extends State<SelectUserPage> {
  final List<String> users = ['admin1', 'recepcionista', 'gerente'];
  String? selectedUser;
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A2A2A),
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Seleccionar usuario',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButtonFormField<String>(
              dropdownColor: const Color.fromARGB(
                255,
                192,
                190,
                190,
              ), // fondo gris claro
              style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[300],
                hintText: 'Seleccionar usuario',
                hintStyle: const TextStyle(color: Color.fromARGB(137, 0, 0, 0)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              items:
                  users.map((user) {
                    return DropdownMenuItem(value: user, child: Text(user));
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedUser = value;
                });
              },
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              obscureText: true,
              style: const TextStyle(color: Colors.black87),
              decoration: InputDecoration(
                hintText: 'CLAVE',
                hintStyle: const TextStyle(color: Colors.black54),
                filled: true,
                fillColor: Colors.grey[300],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildButton(
                  text: 'Aceptar',
                  color: const Color(0xFFFF9800),
                  onPressed: () {
                    if (selectedUser != null &&
                        _passwordController.text.isNotEmpty) {
                      // Simulamos acceso (luego se valida contra DB)
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const HomePage()),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Seleccione un usuario y escriba la clave',
                          ),
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(width: 16),
                _buildButton(
                  text: 'Cancelar',
                  color: Colors.blue,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton({
    required String text,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      child: Text(text, style: const TextStyle(color: Colors.white)),
    );
  }
}
