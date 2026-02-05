// file: lib/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'main.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: GlobalData.fetchBookings(), // โหลดข้อมูลก่อนคำนวณ
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final bookings = snapshot.data ?? [];
          
          final totalCount = bookings.length;
          final pendingCount = bookings.where((b) => b['status'] == 'Pending').length;
          final completedCount = bookings.where((b) => b['status'] == 'Completed').length;
          final totalIncome = bookings.fold(0.0, (sum, b) {
             double price = 0.0;
             if(b['price'] is int) price = (b['price'] as int).toDouble();
             if(b['price'] is double) price = b['price'];
             return sum + price;
          });

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildCard("ยอดจองวันนี้", "$totalCount รายการ", Icons.list_alt, Colors.blue),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(child: _buildCard("รออนุมัติ", "$pendingCount", Icons.pending, Colors.red)),
                    const SizedBox(width: 15),
                    Expanded(child: _buildCard("เสร็จสิ้น", "$completedCount", Icons.check_circle, Colors.green)),
                  ],
                ),
                const SizedBox(height: 15),
                _buildCard("รายได้รวม", "฿${totalIncome.toStringAsFixed(0)}", Icons.monetization_on, Colors.teal),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: color.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Column(
        children: [
          Icon(icon, size: 40, color: color),
          const SizedBox(height: 10),
          Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
          Text(title, style: TextStyle(color: Colors.grey[600])),
        ],
      ),
    );
  }
}