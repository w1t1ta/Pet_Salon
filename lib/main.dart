import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'login_screen.dart';

void main() {
  runApp(const PetSalonApp());
}

class PetSalonApp extends StatelessWidget {
  const PetSalonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pet Salon Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          primary: const Color(0xFFFF8FAB),
          secondary: const Color(0xFF85E3FF),
          surface: const Color(0xFFFFF5F5),
        ),
        scaffoldBackgroundColor: const Color(0xFFFFF5F5),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: Color(0xFFFF8FAB),
          foregroundColor: Colors.white,
          elevation: 0,
          titleTextStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF8FAB),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          ),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}

// --- Global Data (API Connected) ---
class GlobalData {
  static const String baseUrl = 'https://my-json-server.typicode.com/w1t1ta/pet-salon-api';

  // --- Helpers แปลงค่า ---
  static IconData getIconFromName(String name) {
    switch (name) {
      case 'bathtub': return Icons.bathtub;
      case 'cut': return Icons.cut;
      case 'spa': return Icons.spa;
      case 'pets': return Icons.pets;
      default: return Icons.pets;
    }
  }

  static Color getColorFromHex(String hexColor) {
    try {
      hexColor = hexColor.replaceAll("#", "");
      if (hexColor.length == 6) hexColor = "FF$hexColor";
      return Color(int.parse("0x$hexColor"));
    } catch (e) {
      return Colors.pink[200]!;
    }
  }

  // --- API Functions ---

  // 1. ดึงข้อมูล Services
  static Future<List<Map<String, dynamic>>> fetchServices() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/services'));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => {
          'id': item['id'].toString(),
          'name': item['name'],
          'price': double.tryParse(item['price'].toString()) ?? 0.0,
          'icon': getIconFromName(item['icon_name'] ?? ''),
          'color': getColorFromHex(item['color_hex'] ?? '#F48FB1'),
        }).toList();
      }
      return [];
    } catch (e) {
      print("Error fetching services: $e");
      return [];
    }
  }

  // 2. ดึงข้อมูล Bookings
  static Future<List<Map<String, dynamic>>> fetchBookings() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/bookings'));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => item as Map<String, dynamic>).toList();
      }
      return [];
    } catch (e) {
      print("Error fetching bookings: $e");
      return [];
    }
  }

  // 3. เพิ่ม Booking (POST)
  static Future<bool> addBooking(Map<String, dynamic> bookingData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/bookings'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(bookingData),
      );
      // My JSON Server จะคืนค่า 201 Created (แต่ข้อมูลจะไม่เซฟถาวรในเซิร์ฟเวอร์จริง)
      return response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  // 4. อัปเดตสถานะ Booking (PATCH)
  static Future<bool> updateBookingStatus(String id, String newStatus) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/bookings/$id'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"status": newStatus}),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // 5. ลบ Booking (DELETE)
  static Future<bool> deleteBooking(String id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/bookings/$id'));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
  
  // 6. ลบ Service (DELETE)
  static Future<bool> deleteService(String id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/services/$id'));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}