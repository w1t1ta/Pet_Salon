// file: lib/home_screen.dart
import 'package:flutter/material.dart';
import 'main.dart';

class HomeScreen extends StatefulWidget {
  final bool isAdmin;
  const HomeScreen({super.key, required this.isAdmin});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Map<String, dynamic>>> _servicesFuture;

  @override
  void initState() {
    super.initState();
    _refreshServices();
  }

  void _refreshServices() {
    setState(() {
      _servicesFuture = GlobalData.fetchServices();
    });
  }

  void _deleteService(String id) async {
    bool confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("ลบบริการ"),
        content: const Text("ต้องการลบบริการนี้ใช่หรือไม่?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("ยกเลิก")),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("ลบ", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    ) ?? false;

    if (confirm) {
      await GlobalData.deleteService(id);
      _refreshServices(); // โหลดใหม่หลังจากลบ
    }
  }

  // หมายเหตุ: My JSON Server เพิ่ม service ไม่ได้จริง (มันจะไม่จำ) แต่ใส่โครงไว้ให้ครับ
  void _addServiceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("แจ้งเตือน"),
        content: const Text("API นี้เป็นแบบจำลอง (Read-only) การเพิ่มข้อมูลอาจไม่บันทึกถาวร"),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("ตกลง"))],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _servicesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("ไม่พบข้อมูลบริการ"));
          }

          final services = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: services.length,
            itemBuilder: (context, index) {
              final service = services[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                color: Colors.pink[50],
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: service['color'].withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(service['icon'], color: service['color'], size: 30),
                  ),
                  title: Text(service['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('ราคา ฿${service['price'].toStringAsFixed(0)}'),
                  trailing: widget.isAdmin
                      ? IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteService(service['id']),
                        )
                      : null,
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: widget.isAdmin
          ? FloatingActionButton(
              backgroundColor: const Color(0xFFFF8FAB),
              onPressed: _addServiceDialog,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }
}