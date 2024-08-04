import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tukangapptwo/app/modules/ratingulasan/views/ratingulasan_view.dart';

import '../controllers/detailhistorypesanan_user_controller.dart';

class DetailhistorypesananUserView extends GetView<DetailhistorypesananUserController> {
  final String orderId;

  const DetailhistorypesananUserView({Key? key, required this.orderId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Pesanan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        centerTitle: true,
        backgroundColor: Color(0xFF9A0000),
        elevation: 0,
      ),
      body: DetailHistoryPesananBody(orderId: orderId),
    );
  }
}

class DetailHistoryPesananBody extends StatefulWidget {
  final String orderId;

  const DetailHistoryPesananBody({Key? key, required this.orderId}) : super(key: key);

  @override
  _DetailHistoryPesananBodyState createState() => _DetailHistoryPesananBodyState();
}

class _DetailHistoryPesananBodyState extends State<DetailHistoryPesananBody> {
  final DatabaseReference _ordersRef = FirebaseDatabase.instance.ref().child('orders');
  final DatabaseReference _usersRef = FirebaseDatabase.instance.ref().child('users');

  Widget _buildInfoRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingRow(String label, dynamic rating) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              children: [
                ...List.generate(5, (index) {
                  return Icon(
                    index < (rating ?? 0) ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 20,
                  );
                }),
                SizedBox(width: 5),
                Text('(${rating ?? 0}/5)'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _ordersRef.child(widget.orderId).onValue,
      builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFF9A0000)));
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.red)));
        }

        if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
          return const Center(child: Text('Data pesanan tidak ditemukan', style: TextStyle(fontSize: 16)));
        }

        Map<dynamic, dynamic> orderDetails = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;

        return FutureBuilder(
          future: Future.wait([
            _usersRef.child(orderDetails['pemesanId']).once(),
            _usersRef.child(orderDetails['tukangId']).once(),
          ]),
          builder: (context, AsyncSnapshot<List<DatabaseEvent>> userSnapshots) {
            if (userSnapshots.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: Color(0xFF9A0000)));
            }

            if (userSnapshots.hasData) {
              orderDetails['pemesanName'] = (userSnapshots.data![0].snapshot.value as Map)['name'];
              orderDetails['tukangName'] = (userSnapshots.data![1].snapshot.value as Map)['name'];
            }

            return SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow('ID Pesanan', widget.orderId, isBold: true),
                      Divider(height: 24, thickness: 1),
                      _buildInfoRow('Tanggal', orderDetails['tanggal'] ?? 'Tidak tersedia'),
                      _buildInfoRow('Status', orderDetails['status'] ?? 'Tidak tersedia'),
                      _buildInfoRow('Pemesan', orderDetails['pemesanName'] ?? 'Tidak tersedia'),
                      _buildInfoRow('Tukang', orderDetails['tukangName'] ?? 'Tidak tersedia'),
                      _buildInfoRow('Alamat', orderDetails['alamat'] ?? 'Tidak tersedia'),
                      if (orderDetails.containsKey('pekerjaan')) 
                        _buildInfoRow('Pekerjaan', orderDetails['pekerjaan']),
                      if (orderDetails.containsKey('totalLuas')) 
                        _buildInfoRow('Total Luas', '${orderDetails['totalLuas']} m²'),
                      if (orderDetails.containsKey('totalBiaya')) 
                        _buildInfoRow('Total Biaya', 'Rp ${orderDetails['totalBiaya']}'),
                      if (orderDetails.containsKey('tanggalMulai')) 
                        _buildInfoRow('Tanggal Mulai', orderDetails['tanggalMulai']),
                      if (orderDetails.containsKey('tanggalSelesai')) 
                        _buildInfoRow('Tanggal Selesai', orderDetails['tanggalSelesai']),
                      if (orderDetails.containsKey('statusPayment')) 
                        _buildInfoRow('Status Pembayaran', orderDetails['statusPayment']),
                      if (orderDetails.containsKey('estimasi')) 
                        _buildInfoRow('Estimasi', orderDetails['estimasi']),
                      if (orderDetails.containsKey('reason')) 
                        _buildInfoRow('Alasan', orderDetails['reason']),
                      if (orderDetails.containsKey('rating')) 
                        _buildRatingRow('Rating', orderDetails['rating']),
                      if (orderDetails.containsKey('review')) 
                        _buildInfoRow('Ulasan', orderDetails['review']),
                      SizedBox(height: 20),
                      if (!orderDetails.containsKey('rating') || !orderDetails.containsKey('review'))
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              Get.to(() => RatingulasanView(orderId: widget.orderId));
                            },
                            child: const Text('Beri Nilai', style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF9A0000),
                              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}