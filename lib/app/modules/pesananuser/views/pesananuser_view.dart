import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:tukangapptwo/app/modules/component/navbar_view.dart';
import 'package:tukangapptwo/app/modules/dashboarduser/views/dashboarduser_view.dart';
import 'package:tukangapptwo/app/modules/detailpesananuser/views/detailpesananuser_view.dart';
import 'package:tukangapptwo/app/modules/pembayaranpesananuser/views/pembayaranpesananuser_view.dart';
import 'package:tukangapptwo/app/modules/profilscreen/views/profilscreen_view.dart';

class PesananUser extends StatefulWidget {
  const PesananUser({super.key});

  @override
  State<PesananUser> createState() => _PesananUser();
}

class _PesananUser extends State<PesananUser> {
  int _currentIndex = 3;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  bool _isPemesan = false;
  String _userRole = '';

  @override
  void initState() {
    super.initState();
    _checkUserRole();
  }

  void _checkUserRole() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DatabaseEvent event = await _database.child('users/${user.uid}/role').once();
      DataSnapshot snapshot = event.snapshot;
      if (snapshot.value != null) {
        String role = snapshot.value as String;
        setState(() {
          _userRole = role;
          if (role == 'pemesan') {
            _isPemesan = true;
          }
        });
      }
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
      if (index == 3) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PesananUser()),
        );
      }

      if (index == 1) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfilscreenView()),
        );
      }
      if (index == 0) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DashboarduserView()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pesanan Saya',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600, // Semi-bold
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF9A0000),
        elevation: 0,
      ),
      body: StreamBuilder(
        stream: _database.child('orders').orderByChild('pemesanId').equalTo(_auth.currentUser?.uid).onValue,
        builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFF9A0000)));
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.red)));
          }

          if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
            return const Center(child: Text('Tidak ada pesanan', style: TextStyle(fontSize: 18)));
          }

          Map<dynamic, dynamic> ordersMap = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
          List<Map<dynamic, dynamic>> orders = [];

          ordersMap.forEach((key, value) {
            if (value['status'] != 'tolak' && value['status'] != 'selesai') {
              Map<dynamic, dynamic> order = value;
              order['orderId'] = key;
              orders.add(order);
            }
          });

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return FutureBuilder(
                future: Future.wait([
                  _database.child('users/${order['pemesanId']}').once(),
                  _database.child('users/${order['tukangId']}').once(),
                ]),
                builder: (context, AsyncSnapshot<List<DatabaseEvent>> userSnapshots) {
                  if (userSnapshots.connectionState == ConnectionState.waiting) {
                    return Card(
                      margin: EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text('Memuat data...'),
                      ),
                    );
                  }

                  if (userSnapshots.hasData) {
                    final pemesanData = userSnapshots.data![0].snapshot.value as Map?;
                    final tukangData = userSnapshots.data![1].snapshot.value as Map?;
                    final pemesanName = pemesanData?['name'] ?? 'Tidak tersedia';
                    final tukangName = tukangData?['name'] ?? 'Tidak tersedia';

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailpesananuserView(
                              orderId: order['orderId'],
                              pemesanName: pemesanName,
                              tukangName: tukangName,
                            ),
                          ),
                        );
                      },
                      child: Card(
                        margin: EdgeInsets.all(12.0),
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Alamat: ${order['alamat'] ?? 'Tidak tersedia'}', 
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              SizedBox(height: 8),
                              _buildInfoRow('Tanggal', order['tanggal']),
                              _buildInfoRow('Status', order['status']),
                              _buildInfoRow('Pemesan', pemesanName),
                              _buildInfoRow('Tukang', tukangName),
                              if (order.containsKey('statusPayment')) _buildInfoRow('Status Pembayaran', order['statusPayment']),
                              if (order.containsKey('totalBiaya')) _buildInfoRow('Total Biaya', order['totalBiaya']),
                              SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ),
                    );
                  }

                  return Card(
                    margin: EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text('Gagal memuat data'),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        userRole: _userRole,
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