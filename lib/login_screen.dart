import 'package:flutter/material.dart';
import 'main_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.pink.withOpacity(0.1),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: const Icon(Icons.pets, size: 80, color: Color(0xFFFF8FAB)),
            ),
            const SizedBox(height: 30),
            const Text(
              "Pet Salon Manager",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 86, 86, 86),
              ),
            ),
            const SizedBox(height: 10),

            // ปุ่มลูกค้า
            ElevatedButton.icon(
              icon: const Icon(Icons.person),
              label: const Text("ลูกค้า (User)"),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MainScreen(isAdmin: false),
                  ),
                );
              },
            ),
            const SizedBox(height: 15),

            // ปุ่มแอดมิน
            ElevatedButton.icon(
              icon: const Icon(Icons.person),
              label: const Text("เจ้าของร้าน (Admin)"),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MainScreen(isAdmin: true),
                  ),
                );
              },
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
