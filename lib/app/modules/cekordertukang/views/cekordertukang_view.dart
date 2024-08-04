import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class CekOrderTukangView extends StatefulWidget {
  const CekOrderTukangView({super.key});

  @override
  _CekOrderTukangViewState createState() => _CekOrderTukangViewState();
}

class _CekOrderTukangViewState extends State<CekOrderTukangView> {
  final DatabaseReference _ordersRef = FirebaseDatabase.instance.ref().child('orders');
  final DatabaseReference _usersRef = FirebaseDatabase.instance.ref().child('users');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<Map<dynamic, dynamic>> _orderList = [];
  String? _userId;

  @override
  void initState() {
    super.initState();
    _userId = _auth.currentUser?.uid;
    _fetchOrders();
  }

  void _fetchOrders() {
    _ordersRef.once().then((DatabaseEvent event) async {
      List<Map<dynamic, dynamic>> tempList = [];
      final snapshot = event.snapshot;
      if (snapshot.value != null) {
        for (var entry in (snapshot.value as Map).entries) {
          var key = entry.key;
          var value = entry.value;
          value['id'] = key; // Tambahkan ID order ke data
          if (value['tukangId'] == _userId && 
              (value['konfirmasiTukang'] == 'pending' || value['konfirmasiTukang'] == 'terima') && 
              value['status'] != 'selesai') { // Filter pesanan berdasarkan ID tukang, status konfirmasi, dan status selesai
            // Ambil nama pemesan dan tukang
            var pemesanSnapshot = await _usersRef.child(value['pemesanId']).once();
            var tukangSnapshot = await _usersRef.child(value['tukangId']).once();
            if (pemesanSnapshot.snapshot.value != null && tukangSnapshot.snapshot.value != null) {
              value['pemesanName'] = (pemesanSnapshot.snapshot.value as Map)['name'];
              value['tukangName'] = (tukangSnapshot.snapshot.value as Map)['name'];
            }
            tempList.add(value);
          }
        }
      }
      setState(() {
        _orderList = tempList;
      });
      print('Fetched orders: $_orderList'); // Logging untuk debugging
    }).catchError((error) {
      print('Error fetching orders: $error'); // Logging untuk error
    });
  }

  void _updateOrderStatus(String orderId, String newStatus, {String? alasan, String? statusPayment}) async {
    Map<String, dynamic> updates = {'konfirmasiTukang': newStatus};
    if (alasan != null) {
      updates['alasanPenolakan'] = alasan;
    }
    if (statusPayment != null) {
      updates['statusPayment'] = statusPayment;
    }
    await _ordersRef.child(orderId).update(updates);
    _fetchOrders(); // Refresh orders after updating status
  }

  void _showRejectDialog(String orderId) {
    TextEditingController alasanController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alasan Penolakan'),
          content: TextField(
            controller: alasanController,
            decoration: const InputDecoration(hintText: "Masukkan alasan penolakan"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Kirim'),
              onPressed: () {
                _updateOrderStatus(orderId, 'ditolak', alasan: alasanController.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cek Order Tukang',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600, // Semi-bold
          ),
        ),
        backgroundColor: Color(0xFF9A0000),
        elevation: 0,
      ),
      body: _orderList.isEmpty
          ? const Center(
              child: Text('Belum ada order yang perlu di-cek.', style: TextStyle(fontSize: 16)),
            )
          : ListView.builder(
              itemCount: _orderList.length,
              itemBuilder: (context, index) {
                final order = _orderList[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 2,
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Alamat: ${order['alamat']}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        SizedBox(height: 8),
                        _buildInfoRow('Tanggal', order['tanggal']),
                        _buildInfoRow('Estimasi', order['estimasi']),
                        _buildInfoRow('Konfirmasi Tukang', order['konfirmasiTukang']),
                        _buildInfoRow('Status', order['status']),
                        _buildInfoRow('Tanggal Mulai', order['tanggalMulai']),
                        _buildInfoRow('Total Luas', order['totalLuas']),
                        _buildInfoRow('Pemesan', order['pemesanName']),
                        _buildInfoRow('Tukang', order['tukangName']),
                        if (order['konfirmasiTukang'] == 'pending') ...[
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  _updateOrderStatus(order['id'], 'terima', statusPayment: 'belum lunas');
                                },
                                child: const Text('Terima', style: TextStyle(color: Colors.white)), // Ubah warna teks menjadi putih
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF9A0000),
                                  textStyle: TextStyle(color: Colors.white), // Tambahkan ini untuk memastikan
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  _showRejectDialog(order['id']);
                                },
                                child: const Text('Tolak', style: TextStyle(color: Colors.white)), // Ubah warna teks menjadi putih
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey,
                                  textStyle: TextStyle(color: Colors.white), // Tambahkan ini untuk memastikan
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildInfoRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text('$label:', style: TextStyle(fontWeight: FontWeight.w500)),
          ),
          Expanded(
            child: Text('${value ?? 'Tidak tersedia'}'),
          ),
        ],
      ),
    );
  }
}