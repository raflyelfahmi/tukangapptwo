import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class PembayaranpesananuserView extends StatefulWidget {
  final String orderId;

  const PembayaranpesananuserView({super.key, required this.orderId});

  @override
  _PembayaranpesananuserViewState createState() => _PembayaranpesananuserViewState();
}

class _PembayaranpesananuserViewState extends State<PembayaranpesananuserView> {
  final DatabaseReference _ordersRef = FirebaseDatabase.instance.ref().child('orders');
  final DatabaseReference _usersRef = FirebaseDatabase.instance.ref().child('users');
  Map<dynamic, dynamic>? _orderDetails;
  String _selectedPaymentMethod = 'Transfer Bank';

  @override
  void initState() {
    super.initState();
    _fetchOrderDetails();
  }

  void _fetchOrderDetails() {
    _ordersRef.child(widget.orderId).once().then((DatabaseEvent event) async {
      final snapshot = event.snapshot;
      if (snapshot.value != null) {
        var orderData = snapshot.value as Map<dynamic, dynamic>;
        // Ambil nama pemesan dan tukang
        var pemesanSnapshot = await _usersRef.child(orderData['pemesanId']).once();
        var tukangSnapshot = await _usersRef.child(orderData['tukangId']).once();
        if (pemesanSnapshot.snapshot.value != null && tukangSnapshot.snapshot.value != null) {
          orderData['pemesanName'] = (pemesanSnapshot.snapshot.value as Map)['name'];
          orderData['tukangName'] = (tukangSnapshot.snapshot.value as Map)['name'];
        }
        setState(() {
          _orderDetails = orderData;
        });
      }
    }).catchError((error) {
      print('Error fetching order details: $error'); // Logging untuk error
    });
  }

  void _updatePaymentStatus() {
    _ordersRef.child(widget.orderId).update({'statusPayment': 'lunas'}).then((_) {
      print('Payment status updated to lunas'); // Logging untuk debugging
      Navigator.of(context).pop(); // Kembali ke halaman sebelumnya setelah pembayaran
    }).catchError((error) {
      print('Error updating payment status: $error'); // Logging untuk error
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pembayaran Pesanan',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Color(0xFF9A0000),
        elevation: 0,
      ),
      body: _orderDetails == null
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF9A0000)))
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow('Alamat', _orderDetails!['alamat']),
                        _buildInfoRow('Tanggal', _orderDetails!['tanggal']),
                        _buildInfoRow('Status', _orderDetails!['status']),
                        _buildInfoRow('Pemesan', _orderDetails!['pemesanName']),
                        _buildInfoRow('Tukang', _orderDetails!['tukangName']),
                        _buildInfoRow('Status Pembayaran', _orderDetails!['statusPayment']),
                        if (_orderDetails!.containsKey('totalLuas')) _buildInfoRow('Total Luas', _orderDetails!['totalLuas']),
                        if (_orderDetails!.containsKey('estimasi')) _buildInfoRow('Estimasi', _orderDetails!['estimasi']),
                        if (_orderDetails!.containsKey('pekerjaan')) _buildInfoRow('Pekerjaan', _orderDetails!['pekerjaan']),
                        if (_orderDetails!.containsKey('tanggalMulai')) _buildInfoRow('Tanggal Mulai', _orderDetails!['tanggalMulai']),
                        if (_orderDetails!.containsKey('totalBiaya')) _buildInfoRow('Total Biaya', _orderDetails!['totalBiaya']),
                        const SizedBox(height: 16),
                        Text('Pilih Metode Pembayaran:', style: TextStyle(fontWeight: FontWeight.bold)),
                        DropdownButton<String>(
                          isExpanded: true,
                          value: _selectedPaymentMethod,
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedPaymentMethod = newValue!;
                            });
                          },
                          items: <String>['Transfer Bank', 'Kartu Kredit', 'E-Wallet']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 24),
                        Center(
                          child: ElevatedButton(
                            onPressed: _updatePaymentStatus,
                            child: const Text('Bayar', style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF9A0000),
                              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
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