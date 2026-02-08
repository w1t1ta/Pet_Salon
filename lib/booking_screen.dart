import 'package:flutter/material.dart';
import 'main.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _petNameCtrl = TextEditingController();
  
  String? _selectedServiceId;
  String _petType = 'Dog';
  
  List<Map<String, dynamic>> _services = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadServices();
  }

  Future<void> _loadServices() async {
    final data = await GlobalData.fetchServices();
    setState(() {
      _services = data;
      _isLoading = false;
    });
  }

  void _submit() async {
    if (_formKey.currentState!.validate() && _selectedServiceId != null) {
      final service = _services.firstWhere((s) => s['id'] == _selectedServiceId);

      final newBooking = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(), 
        'customerName': _nameCtrl.text,
        'petName': _petNameCtrl.text,
        'petType': _petType,
        'serviceName': service['name'],
        'price': service['price'],
        'status': 'Pending',
        'date': DateTime.now().toIso8601String().split('T')[0],
        'time': "${TimeOfDay.now().hour}:${TimeOfDay.now().minute}",
      };

      showDialog(context: context, barrierDismissible: false, builder: (c) => const Center(child: CircularProgressIndicator()));
      
      bool success = await GlobalData.addBooking(newBooking);
      Navigator.pop(context);

      if (success) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("สำเร็จ"),
            content: const Text("ส่งคำขอจองเรียบร้อยแล้ว"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _nameCtrl.clear();
                  _petNameCtrl.clear();
                  setState(() { _selectedServiceId = null; });
                },
                child: const Text("ตกลง"),
              )
            ],
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("การจองล้มเหลว กรุณาลองใหม่")));
      }
    } else if (_selectedServiceId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("กรุณาเลือกบริการ")));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("ข้อมูลการจอง", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: "ชื่อลูกค้า", prefixIcon: Icon(Icons.person)),
                validator: (v) => v!.isEmpty ? "กรุณากรอกชื่อ" : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _petNameCtrl,
                decoration: const InputDecoration(labelText: "ชื่อสัตว์เลี้ยง", prefixIcon: Icon(Icons.pets)),
                validator: (v) => v!.isEmpty ? "กรุณากรอกชื่อสัตว์เลี้ยง" : null,
              ),
              const SizedBox(height: 20),
              const Text("ประเภทสัตว์เลี้ยง:"),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile(
                      title: const Text("สุนัข"), value: "Dog", groupValue: _petType,
                      onChanged: (v) => setState(() => _petType = v.toString()),
                      activeColor: const Color(0xFFFF8FAB),
                    ),
                  ),
                  Expanded(
                    child: RadioListTile(
                      title: const Text("แมว"), value: "Cat", groupValue: _petType,
                      onChanged: (v) => setState(() => _petType = v.toString()),
                      activeColor: const Color(0xFFFF8FAB),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: "เลือกบริการ", prefixIcon: Icon(Icons.cut)),
                value: _selectedServiceId,
                items: _services.map((s) {
                  return DropdownMenuItem<String>(
                    value: s['id'],
                    child: Text("${s['name']} (฿${s['price'].toInt()})"),
                  );
                }).toList(),
                onChanged: (v) => setState(() => _selectedServiceId = v),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _submit,
                  child: const Text("ยืนยันการจอง", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}