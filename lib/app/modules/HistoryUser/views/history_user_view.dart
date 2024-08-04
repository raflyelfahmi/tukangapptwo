import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tukangapptwo/app/modules/detailhistorypesanan_user/views/detailhistorypesanan_user_view.dart';

class HistoryUserView extends StatefulWidget {
  const HistoryUserView({super.key});

  @override
  _HistoryUserViewState createState() => _HistoryUserViewState();
}

class _HistoryUserViewState extends State<HistoryUserView> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.reference();
  bool _isLoading = true;
  List<Map> _historyOrders = [];

  @override
  void initState() {
    super.initState();
    _loadHistoryOrders();
  }

  void _loadHistoryOrders() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DatabaseEvent event = await _database.child('orders').orderByChild('pemesanId').equalTo(user.uid).once();
      DataSnapshot snapshot = event.snapshot;
      if (snapshot.value != null) {
        Map ordersMap = snapshot.value as Map;
        List<Map> tempList = [];
        for (var entry in ordersMap.entries) {
          var order = entry.value;
          order['orderId'] = entry.key;
          if (order['status'] == 'tolak' || order['status'] == 'selesai') {
            // Ambil nama pemesan dan tukang
            var pemesanSnapshot = await _database.child('users/${order['pemesanId']}').once();
            var tukangSnapshot = await _database.child('users/${order['tukangId']}').once();
            if (pemesanSnapshot.snapshot.value != null && tukangSnapshot.snapshot.value != null) {
              order['pemesanName'] = (pemesanSnapshot.snapshot.value as Map)['name'];
              order['tukangName'] = (tukangSnapshot.snapshot.value as Map)['name'];
            }
            tempList.add(order);
          }
        }
        setState(() {
          _historyOrders = tempList;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Pesanan'),
        centerTitle: true,
      ),
      body: _historyOrders.isEmpty
          ? const Center(
              child: Text('Tidak ada pesanan yang ditolak atau selesai.'),
            )
          : ListView.builder(
              itemCount: _historyOrders.length,
              itemBuilder: (context, index) {
                final order = _historyOrders[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: GestureDetector(
                    onTap: order['status'] == 'selesai'
                        ? () {
                            Get.to(() => DetailhistorypesananUserView(orderId: order['orderId']));
                          }
                        : null,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(Icons.calendar_today, color: Color(0xff9a0000)),
                                  Text(
                                    order['tanggal'] ?? 'Tanggal tidak tersedia',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: order['status'] == 'selesai' ? Color(0xFFFFE0E0) : Colors.grey[200],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      order['status'] == 'selesai' ? 'Selesai' : 'Ditolak',
                                      style: TextStyle(
                                        color: order['status'] == 'selesai' ? Color(0xFF9A0000) : Colors.black54,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12),
                              Row(
                                children: [
                                  Icon(Icons.person, color: Color(0xff9a0000)),
                                  SizedBox(width: 8),
                                  Text(order['tukangName'] ?? 'Nama tukang tidak tersedia'),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.location_on, color: Color(0xff9a0000)),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(order['alamat'] ?? 'Alamat tidak tersedia'),
                                  ),
                                ],
                              ),
                              if (order.containsKey('pekerjaan')) ...[
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(Icons.work, color: Color(0xff9a0000)),
                                    SizedBox(width: 8),
                                    Text(order['pekerjaan']),
                                  ],
                                ),
                              ],
                              if (order['status'] == 'tolak') ...[
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(Icons.info_outline, color: Color(0xff9a0000)),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Text('Alasan: ${order['reason'] ?? 'Tidak ada alasan'}'),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}