import 'package:flutter/material.dart';
import 'main.dart';

class HistoryScreen extends StatefulWidget {
  final bool isAdmin;
  const HistoryScreen({super.key, required this.isAdmin});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late Future<List<Map<String, dynamic>>> _bookingsFuture;

  @override
  void initState() {
    super.initState();
    _refreshBookings();
  }

  void _refreshBookings() {
    setState(() {
      _bookingsFuture = GlobalData.fetchBookings();
    });
  }

  void _updateStatus(String id, String newStatus) async {
    await GlobalData.updateBookingStatus(id, newStatus);
    _refreshBookings();
  }

  void _deleteBooking(String id) async {
    await GlobalData.deleteBooking(id);
    _refreshBookings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _bookingsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (!snapshot.hasData || snapshot.data!.isEmpty) return const Center(child: Text("ไม่มีรายการจอง"));

          final bookings = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];
              final String id = booking['id'].toString();
              
              Color statusColor = Colors.orange;
              String statusText = "รออนุมัติ";
              String status = booking['status'] ?? 'Pending';

              if (status == 'Confirmed') { statusColor = Colors.blue; statusText = "รับงานแล้ว"; }
              if (status == 'Completed') { statusColor = Colors.green; statusText = "เสร็จสิ้น"; }

              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          backgroundColor: booking['petType'] == 'Dog' ? Colors.blue[50] : Colors.orange[50],
                          child: Text(booking['petType'] == 'Dog' ? '🐶' : '🐱'),
                        ),
                        title: Text(booking['serviceName'] ?? ""),
                        subtitle: Text("ลูกค้า: ${booking['customerName']} (น้อง${booking['petName']})"),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                          child: Text(statusText, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const Divider(),
                      
                      if (widget.isAdmin) 
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (status == 'Pending')
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                                onPressed: () => _updateStatus(id, 'Confirmed'),
                                child: const Text("รับงาน"),
                              ),
                            const SizedBox(width: 8),
                            if (status == 'Confirmed')
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                onPressed: () => _updateStatus(id, 'Completed'),
                                child: const Text("เสร็จสิ้น"),
                              ),
                            IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _deleteBooking(id))
                          ],
                        )
                      else if (status == 'Pending')
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton.icon(
                            icon: const Icon(Icons.cancel, color: Colors.red, size: 18),
                            label: const Text("ยกเลิกการจอง", style: TextStyle(color: Colors.red)),
                            onPressed: () => _deleteBooking(id),
                          ),
                        )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}