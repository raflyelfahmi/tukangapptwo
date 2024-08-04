import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class DetailhistorypesananTukangView extends StatelessWidget {
  final String orderId;
  final DatabaseReference _database = FirebaseDatabase.instance.reference();
  final DatabaseReference _usersRef = FirebaseDatabase.instance.reference().child('users');

  DetailhistorypesananTukangView({Key? key, required this.orderId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Pesanan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        centerTitle: true,
        backgroundColor: Color(0xFF9A0000),
        elevation: 0,
      ),
      body: FutureBuilder(
        future: _database.child('orders/$orderId').once(),
        builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: Color(0xFF9A0000)));
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.red)));
          }

          if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
            return Center(child: Text('Data pesanan tidak ditemukan', style: TextStyle(fontSize: 16)));
          }

          Map<dynamic, dynamic> orderData = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;

          return FutureBuilder(
            future: _usersRef.child(orderData['pemesanId']).once(),
            builder: (context, AsyncSnapshot<DatabaseEvent> userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator(color: Color(0xFF9A0000)));
              }

              if (userSnapshot.hasData && userSnapshot.data!.snapshot.value != null) {
                Map<dynamic, dynamic> userData = userSnapshot.data!.snapshot.value as Map<dynamic, dynamic>;
                orderData['pemesanName'] = userData['name'];
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
                        _buildInfoRow('ID Pesanan', orderId, isBold: true),
                        Divider(height: 24, thickness: 1),
                        _buildInfoRow('Tanggal', orderData['tanggal'] ?? 'Tidak tersedia'),
                        _buildInfoRow('Status', orderData['status'] ?? 'Tidak tersedia'),
                        _buildInfoRow('Pemesan', orderData['pemesanName'] ?? 'Tidak tersedia'),
                        _buildInfoRow('Alamat', orderData['alamat'] ?? 'Tidak tersedia'),
                        if (orderData.containsKey('pekerjaan')) 
                          _buildInfoRow('Pekerjaan', orderData['pekerjaan']),
                        if (orderData.containsKey('totalLuas')) 
                          _buildInfoRow('Total Luas', '${orderData['totalLuas']} m²'),
                        if (orderData.containsKey('totalBiaya')) 
                          _buildInfoRow('Total Biaya', 'Rp ${orderData['totalBiaya']}'),
                        if (orderData.containsKey('tanggalMulai')) 
                          _buildInfoRow('Tanggal Mulai', orderData['tanggalMulai']),
                        if (orderData.containsKey('tanggalSelesai')) 
                          _buildInfoRow('Tanggal Selesai', orderData['tanggalSelesai']),
                        if (orderData.containsKey('rating')) 
                          _buildRatingRow('Rating', orderData['rating']),
                        if (orderData.containsKey('review')) 
                          _buildInfoRow('Ulasan', orderData['review']),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

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
}