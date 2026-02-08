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
      _refreshServices();
    }
  }

  void _addServiceDialog() {
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    String selectedIcon = 'pets'; 
    String colorHex = '#FF8FAB'; 

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("เพิ่มบริการใหม่"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ช่องกรอกชื่อบริการ
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: "ชื่อบริการ",
                        prefixIcon: Icon(Icons.edit),
                      ),
                    ),
                    const SizedBox(height: 10),
                    
                    // ช่องกรอกราคา
                    TextField(
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "ราคา (บาท)",
                        prefixIcon: Icon(Icons.attach_money),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("ยกเลิก"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF8FAB)),
                  onPressed: () async {
                    if (nameController.text.isEmpty || priceController.text.isEmpty) {
                      return; 
                    }

                    final newService = {
                      "name": nameController.text,
                      "price": int.tryParse(priceController.text) ?? 0,
                      "icon_name": selectedIcon,
                      "color_hex": colorHex,
                    };

                    bool success = await GlobalData.addService(newService);

                    if (success) {
                      Navigator.pop(context); 
                      _refreshServices();     
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('บันทึกไม่สำเร็จ โปรดลองใหม่')),
                      );
                    }
                  },
                  child: const Text("บันทึก", style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
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