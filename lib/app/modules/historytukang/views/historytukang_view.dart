import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tukangapptwo/app/modules/detailhistorypesanan_tukang/views/detailhistorypesanan_tukang_view.dart';

class HistorytukangView extends StatefulWidget {
  const HistorytukangView({super.key});

  @override
  _HistorytukangViewState createState() => _HistorytukangViewState();
}

class _HistorytukangViewState extends State<HistorytukangView> {
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
      DatabaseEvent event = await _database.child('orders').orderByChild('tukangId').equalTo(user.uid).once();
      DataSnapshot snapshot = event.snapshot;
      if (snapshot.value != null) {
        Map ordersMap = snapshot.value as Map;
        List<Map> tempList = [];
        for (var entry in ordersMap.entries) {
          var order = entry.value;
          order['orderId'] = entry.key;
          if (order['status'] == 'selesai') {
            // Ambil nama pemesan
            var pemesanSnapshot = await _database.child('users/${order['pemesanId']}').once();
            if (pemesanSnapshot.snapshot.value != null) {
              order['pemesanName'] = (pemesanSnapshot.snapshot.value as Map)['name'];
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
              child: Text('Tidak ada pesanan yang selesai.'),
            )
          : ListView.builder(
              itemCount: _historyOrders.length,
              itemBuilder: (context, index) {
                final order = _historyOrders[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: GestureDetector(
                    onTap: () {
                      Get.to(() => DetailhistorypesananTukangView(orderId: order['orderId']));
                    },
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
                                  if (order['status'] == 'selesai')
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Color(0xFFFFE0E0),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        'Selesai',
                                        style: TextStyle(
                                          color: Color(0xFF9A0000),
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
                                  Text(order['pemesanName'] ?? 'Nama tidak tersedia'),
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
                              SizedBox(height: 12),
                              Text(
                                'Tanggal',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(order['tanggal'] ?? 'Tanggal tidak tersedia'),
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