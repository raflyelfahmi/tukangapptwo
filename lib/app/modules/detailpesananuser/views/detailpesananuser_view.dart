// import 'package:firebase_database/firebase_database.dart'; // Pastikan ini ada
// import 'package:flutter/material.dart';
// import 'package:tukangapptwo/app/modules/pembayaranpesananuser/views/pembayaranpesananuser_view.dart';

// class DetailpesananuserView extends StatelessWidget {
//   final String orderId;
//   final String pemesanName;
//   final String tukangName;

//   const DetailpesananuserView({
//     super.key, // Menggunakan super.key
//     required this.orderId,
//     required this.pemesanName,
//     required this.tukangName,
//   });

//   void _updateOrderStatus(BuildContext context, String orderId) async {
//     final DatabaseReference _database = FirebaseDatabase.instance.ref();
//     Map<String, dynamic> updates = {
//       'status': 'proses',
//       'konfirmasiTukang': 'pending'
//     };
//     await _database.child('orders/$orderId').update(updates);
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Status pesanan berhasil diperbarui')),
//     );
//   }

//   void _navigateToPembayaran(BuildContext context) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => PembayaranpesananuserView(orderId: orderId),
//       ),
//     );
//   }

//   Widget _buildStatusIcon(String status, String currentStatus, String label) {
//     bool isActive = status == currentStatus;
//     return Column(
//       children: [
//         Stack(
//           alignment: Alignment.center,
//           children: [
//             Icon(
//               Icons.circle,
//               size: 40,
//               color: isActive ? Color(0xFF9A0000) : Colors.grey,
//             ),
//             if (isActive)
//               Icon(
//                 Icons.check,
//                 size: 24,
//                 color: Colors.white,
//               ),
//           ],
//         ),
//         const SizedBox(height: 8),
//         Text(
//           label,
//           style: TextStyle(
//             color: isActive ? Color(0xFF9A0000) : Colors.grey,
//           ),
//         ),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Detail Pesanan'),
//         centerTitle: true,
//       ),
//       body: FutureBuilder<DatabaseEvent>(
//         future: FirebaseDatabase.instance.ref('orders/$orderId').once(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }

//           if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
//             return const Center(child: Text('Detail pesanan tidak ditemukan'));
//           }

//           final orderDetails = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
//           final statusPekerjaan = orderDetails['statusPekerjaan'] ?? 'pending';

//           return Stack(
//             children: [
//               SingleChildScrollView(
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text('Status Pekerjaan:', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                       const SizedBox(height: 16),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           _buildStatusIcon('pending', statusPekerjaan, 'Pending'),
//                           Expanded(
//                             child: Divider(
//                               color: statusPekerjaan == 'pending' ? Colors.grey : Color(0xFF9A0000),
//                               thickness: 2,
//                             ),
//                           ),
//                           _buildStatusIcon('sedang dikerjakan', statusPekerjaan, 'Sedang Dikerjakan'),
//                           Expanded(
//                             child: Divider(
//                               color: statusPekerjaan == 'selesai' ? Color(0xFF9A0000) : Colors.grey,
//                               thickness: 2,
//                             ),
//                           ),
//                           _buildStatusIcon('selesai', orderDetails['status'], 'Selesai'),
//                         ],
//                       ),
//                       const SizedBox(height: 32),
//                       Card(
//                         elevation: 4,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.all(16.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text('ID Pesanan: $orderId', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                               const SizedBox(height: 8),
//                               Text('Pemesan: $pemesanName', style: const TextStyle(fontSize: 16)),
//                               const SizedBox(height: 8),
//                               Text('Tukang: $tukangName', style: const TextStyle(fontSize: 16)),
//                               const SizedBox(height: 8),
//                               Text('Alamat: ${orderDetails['alamat'] ?? '-'}', style: const TextStyle(fontSize: 16)),
//                               const SizedBox(height: 8),
//                               Text('Tanggal: ${orderDetails['tanggal'] ?? '-'}', style: const TextStyle(fontSize: 16)),
//                               const SizedBox(height: 8),
//                               Text('Status: ${orderDetails['status'] ?? '-'}', style: const TextStyle(fontSize: 16)),
//                               const SizedBox(height: 8),
//                               Text('Total Biaya: ${orderDetails['totalKebutuhan'] ?? '-'}', style: const TextStyle(fontSize: 16)),
//                               const SizedBox(height: 8),
//                               Text('Total Luas: ${orderDetails['totalLuas'] ?? '-'}', style: const TextStyle(fontSize: 16)),
//                               const SizedBox(height: 8),
//                               Text('Pekerjaan: ${orderDetails['pekerjaan'] ?? '-'}', style: const TextStyle(fontSize: 16)),
//                               const SizedBox(height: 8),
//                               Text('Tanggal Mulai: ${orderDetails['tanggalMulai'] ?? '-'}', style: const TextStyle(fontSize: 16)),
//                               const SizedBox(height: 8),
//                               Text('Tanggal Berakhir: ${orderDetails['tanggalBerakhir'] ?? '-'}', style: const TextStyle(fontSize: 16)),
//                             ],
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 32),
//                       Text('Bukti Proses:', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                       const SizedBox(height: 16),
//                       FutureBuilder<DatabaseEvent>(
//                         future: FirebaseDatabase.instance.ref('orders/$orderId/buktiImages').once(),
//                         builder: (context, snapshot) {
//                           if (snapshot.connectionState == ConnectionState.waiting) {
//                             return const Center(child: CircularProgressIndicator());
//                           }

//                           if (snapshot.hasError) {
//                             return Center(child: Text('Error: ${snapshot.error}'));
//                           }

//                           if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
//                             return const Center(child: Text('Tidak ada bukti Proses yang diunggah'));
//                           }

//                           final buktiImages = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
//                           return Column(
//                             children: buktiImages.values.map<Widget>((imageUrl) {
//                               return Padding(
//                                 padding: const EdgeInsets.symmetric(vertical: 8.0),
//                                 child: Image.network(imageUrl, height: 200),
//                               );
//                             }).toList(),
//                           );
//                         },
//                       ),
//                       const SizedBox(height: 32),
//                     ],
//                   ),
//                 ),
//               ),
//               Align(
//                 alignment: Alignment.bottomCenter,
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       if (orderDetails['status'] == 'menunggu')
//                         ElevatedButton(
//                           onPressed: () {
//                             _updateOrderStatus(context, orderId);
//                           },
//                           child: const Text(
//                             'Terima',
//                             style: TextStyle(color: Colors.white),
//                           ),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Color(0xFF9A0000),
//                             textStyle: TextStyle(color: Colors.white), // Tambahkan ini untuk memastikan
//                           ),
//                         ),
//                       if (orderDetails['statusPayment'] == 'belum lunas')
//                         ElevatedButton(
//                           onPressed: () {
//                             _navigateToPembayaran(context);
//                           },
//                           child: const Text(
//                             'Bayar Sekarang',
//                             style: TextStyle(color: Colors.white),
//                           ),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Color(0xFF9A0000),
//                             textStyle: TextStyle(color: Colors.white), // Tambahkan ini untuk memastikan
//                           ),
//                         ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }




import 'package:firebase_database/firebase_database.dart'; // Pastikan ini ada
import 'package:flutter/material.dart';
import 'package:tukangapptwo/app/modules/pembayaranpesananuser/views/pembayaranpesananuser_view.dart';

class DetailpesananuserView extends StatelessWidget {
  final String orderId;
  final String pemesanName;
  final String tukangName;

  const DetailpesananuserView({
    super.key, // Menggunakan super.key
    required this.orderId,
    required this.pemesanName,
    required this.tukangName,
  });

  void _updateOrderStatus(BuildContext context, String orderId) async {
    final DatabaseReference _database = FirebaseDatabase.instance.ref();
    Map<String, dynamic> updates = {
      'status': 'proses',
      'konfirmasiTukang': 'pending'
    };
    await _database.child('orders/$orderId').update(updates);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Status pesanan berhasil diperbarui')),
    );
  }

  void _navigateToPembayaran(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PembayaranpesananuserView(orderId: orderId),
      ),
    );
  }

  Widget _buildStatusIcon(String status, String currentStatus, String label) {
    bool isActive = status == currentStatus;
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              Icons.circle,
              size: 40,
              color: isActive ? Color(0xFF9A0000) : Colors.grey,
            ),
            if (isActive)
              Icon(
                Icons.check,
                size: 24,
                color: Colors.white,
              ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: isActive ? Color(0xFF9A0000) : Colors.grey,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Pesanan'),
        centerTitle: true,
      ),
      body: FutureBuilder<DatabaseEvent>(
        future: FirebaseDatabase.instance.ref('orders/$orderId').once(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
            return const Center(child: Text('Detail pesanan tidak ditemukan'));
          }

          final orderDetails = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
          final statusPekerjaan = orderDetails['statusPekerjaan'] ?? 'pending';
          final rincianFiles = orderDetails['rincianFiles'] as Map<dynamic, dynamic>?;

          return Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Status Pekerjaan:', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildStatusIcon('pending', statusPekerjaan, 'Pending'),
                          Expanded(
                            child: Divider(
                              color: statusPekerjaan == 'pending' ? Colors.grey : Color(0xFF9A0000),
                              thickness: 2,
                            ),
                          ),
                          _buildStatusIcon('sedang dikerjakan', statusPekerjaan, 'Sedang Dikerjakan'),
                          Expanded(
                            child: Divider(
                              color: statusPekerjaan == 'selesai' ? Color(0xFF9A0000) : Colors.grey,
                              thickness: 2,
                            ),
                          ),
                          _buildStatusIcon('selesai', orderDetails['status'], 'Selesai'),
                        ],
                      ),
                      const SizedBox(height: 32),
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('ID Pesanan: $orderId', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              Text('Pemesan: $pemesanName', style: const TextStyle(fontSize: 16)),
                              const SizedBox(height: 8),
                              Text('Tukang: $tukangName', style: const TextStyle(fontSize: 16)),
                              const SizedBox(height: 8),
                              Text('Alamat: ${orderDetails['alamat'] ?? '-'}', style: const TextStyle(fontSize: 16)),
                              const SizedBox(height: 8),
                              Text('Tanggal: ${orderDetails['tanggal'] ?? '-'}', style: const TextStyle(fontSize: 16)),
                              const SizedBox(height: 8),
                              Text('Status: ${orderDetails['status'] ?? '-'}', style: const TextStyle(fontSize: 16)),
                              const SizedBox(height: 8),
                              Text('Total Biaya: ${orderDetails['totalKebutuhan'] ?? '-'}', style: const TextStyle(fontSize: 16)),
                              const SizedBox(height: 8),
                              Text('Total Luas: ${orderDetails['totalLuas'] ?? '-'}', style: const TextStyle(fontSize: 16)),
                              const SizedBox(height: 8),
                              Text('Pekerjaan: ${orderDetails['pekerjaan'] ?? '-'}', style: const TextStyle(fontSize: 16)),
                              const SizedBox(height: 8),
                              Text('Tanggal Mulai: ${orderDetails['tanggalMulai'] ?? '-'}', style: const TextStyle(fontSize: 16)),
                              const SizedBox(height: 8),
                              Text('Tanggal Berakhir: ${orderDetails['tanggalBerakhir'] ?? '-'}', style: const TextStyle(fontSize: 16)),
                              const SizedBox(height: 8),
                              if (rincianFiles != null) ...[
                                Text('Rincian Kebutuhan:', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 8),
                                ...rincianFiles.values.map<Widget>((fileUrl) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                    child: Image.network(fileUrl, height: 200),
                                  );
                                }).toList(),
                              ],
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Text('Bukti Proses:', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      FutureBuilder<DatabaseEvent>(
                        future: FirebaseDatabase.instance.ref('orders/$orderId/buktiImages').once(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          }

                          if (snapshot.hasError) {
                            return Center(child: Text('Error: ${snapshot.error}'));
                          }

                          if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
                            return const Center(child: Text('Tidak ada bukti Proses yang diunggah'));
                          }

                          final buktiImages = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
                          return Column(
                            children: buktiImages.values.map<Widget>((imageUrl) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Image.network(imageUrl, height: 200),
                              );
                            }).toList(),
                          );
                        },
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      if (orderDetails['status'] == 'menunggu')
                        ElevatedButton(
                          onPressed: () {
                            _updateOrderStatus(context, orderId);
                          },
                          child: const Text(
                            'Terima',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF9A0000),
                            textStyle: TextStyle(color: Colors.white), // Tambahkan ini untuk memastikan
                          ),
                        ),
                      if (orderDetails['statusPayment'] == 'belum lunas')
                        ElevatedButton(
                          onPressed: () {
                            _navigateToPembayaran(context);
                          },
                          child: const Text(
                            'Bayar Sekarang',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF9A0000),
                            textStyle: TextStyle(color: Colors.white), // Tambahkan ini untuk memastikan
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}