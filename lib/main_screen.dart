import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'booking_screen.dart';
import 'history_screen.dart';
import 'dashboard_screen.dart';
import 'login_screen.dart';

class MainScreen extends StatefulWidget {
  final bool isAdmin;
  const MainScreen({super.key, required this.isAdmin});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    // จัดการหน้าจอตาม Role
    if (widget.isAdmin) {
      _pages = [
        const HomeScreen(isAdmin: true), // จัดการบริการ
        const HistoryScreen(isAdmin: true), // จัดการคิว
        const DashboardScreen(), // ดูยอด
      ];
    } else {
      _pages = [
        const HomeScreen(isAdmin: false), // ดูบริการ
        const BookingScreen(), // จองคิว 
        const HistoryScreen(isAdmin: false), // ดูประวัติ
      ];
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Logout
  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Pet Salon",
          style: TextStyle(color: Color.fromARGB(255, 86, 86, 86)),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'ออกจากระบบ',
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color(0xFFFF8FAB),
        unselectedItemColor: Colors.grey,
        items: widget.isAdmin
            ? const [
                // เมนูแอดมิน
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'บริการ',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.list),
                  label: 'คิวงาน',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.dashboard),
                  label: 'สรุปยอด',
                ),
              ]
            : const [
                // เมนูลูกค้า
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'บริการ',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.add_circle),
                  label: 'จองคิว',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.history),
                  label: 'ประวัติ',
                ),
              ],
      ),
    );
  }
}
