import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:tukangapptwo/app/modules/detailcekorder/views/detailcekorder_view.dart';

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
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailcekorderView(
                          orderId: order['id'],
                          pemesanName: order['pemesanName'],
                          tukangName: order['tukangName'],
                        ),
                      ),
                    );
                  },
                  child: Card(
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
                          _buildInfoRow('Pemesan', order['pemesanName']),
                          _buildInfoRow('Tukang', order['tukangName']),
                        ],
                      ),
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