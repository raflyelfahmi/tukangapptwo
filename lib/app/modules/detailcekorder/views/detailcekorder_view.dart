import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../controllers/detailcekorder_controller.dart';

class DetailcekorderView extends GetView<DetailcekorderController> {
  final String orderId;
  final String pemesanName;
  final String tukangName;

  const DetailcekorderView({
    super.key, // Menggunakan super.key
    required this.orderId,
    required this.pemesanName,
    required this.tukangName,
  });

  void _updateOrderStatus(BuildContext context, String orderId, String newStatus, {String? alasan, String? statusPayment, String? statusPekerjaan}) async {
    final DatabaseReference _database = FirebaseDatabase.instance.ref();
    Map<String, dynamic> updates = {'konfirmasiTukang': newStatus};
    if (alasan != null) {
      updates['alasanPenolakan'] = alasan;
    }
    if (statusPayment != null) {
      updates['statusPayment'] = statusPayment;
    }
    if (statusPekerjaan != null) {
      updates['statusPekerjaan'] = statusPekerjaan;
    }
    await _database.child('orders/$orderId').update(updates);
    if (context.mounted) {
      Navigator.pop(context); // Kembali ke halaman sebelumnya setelah update
    }
  }

  void _showRejectDialog(BuildContext context, String orderId) {
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
                _updateOrderStatus(context, orderId, 'ditolak', alasan: alasanController.text);
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickAndUploadImage(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      File _image = File(image.path);
      await _uploadImage(context, _image);
    }
  }

  Future<void> _uploadImage(BuildContext context, File image) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref().child('bukti_images/${orderId}/${DateTime.now().millisecondsSinceEpoch}');
      UploadTask uploadTask = ref.putFile(image);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      DatabaseReference orderRef = FirebaseDatabase.instance.ref().child('orders').child(orderId);
      await orderRef.child('buktiImages').push().set(downloadUrl);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Bukti berhasil diunggah')));
      }
    } catch (e) {
      print('Failed to upload image: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal mengunggah bukti')));
      }
    }
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

          return Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Status Pekerjaan:', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                              Text('Alamat: ${orderDetails['alamat'] ?? 'Tidak tersedia'}', style: const TextStyle(fontSize: 16)),
                              const SizedBox(height: 8),
                              Text('Tanggal: ${orderDetails['tanggal'] ?? 'Tidak tersedia'}', style: const TextStyle(fontSize: 16)),
                              const SizedBox(height: 8),
                              Text('Status: ${orderDetails['status'] ?? 'Tidak tersedia'}', style: const TextStyle(fontSize: 16)),
                              const SizedBox(height: 8),
                              Text('Total Luas: ${orderDetails['totalLuas'] ?? 'Tidak tersedia'}', style: const TextStyle(fontSize: 16)),
                              const SizedBox(height: 8),
                              Text('Pekerjaan: ${orderDetails['pekerjaan'] ?? 'Tidak tersedia'}', style: const TextStyle(fontSize: 16)),
                              const SizedBox(height: 8),
                              Text('Tanggal Mulai: ${orderDetails['tanggalMulai'] ?? 'Tidak tersedia'}', style: const TextStyle(fontSize: 16)),
                              const SizedBox(height: 8),
                              Text('Tanggal Berakhir: ${orderDetails['tanggalBerakhir'] ?? 'Tidak tersedia'}', style: const TextStyle(fontSize: 16)),
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
                            return const Center(child: Text('Tidak ada bukti proses yang di unggah'));
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
                      if (orderDetails['konfirmasiTukang'] == 'pending')
                        ElevatedButton(
                          onPressed: () {
                            _updateOrderStatus(context, orderId, 'terima', statusPayment: 'belum lunas', statusPekerjaan: 'pending');
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
                      if (orderDetails['konfirmasiTukang'] != 'terima')
                        ElevatedButton(
                          onPressed: () {
                            _showRejectDialog(context, orderId);
                          },
                          child: const Text('Tolak', style: TextStyle(color: Colors.white)), // Ubah warna teks menjadi putih
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                            textStyle: TextStyle(color: Colors.white), // Tambahkan ini untuk memastikan
                          ),
                        ),
                      if (orderDetails['konfirmasiTukang'] == 'terima' && orderDetails['statusPekerjaan'] == 'pending')
                        ElevatedButton(
                          onPressed: () {
                            _updateOrderStatus(context, orderId, 'terima', statusPekerjaan: 'sedang dikerjakan');
                          },
                          child: const Text(
                            'Mulai Kerja',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF9A0000),
                            textStyle: TextStyle(color: Colors.white), // Tambahkan ini untuk memastikan
                          ),
                        ),
                      if (orderDetails['statusPekerjaan'] == 'sedang dikerjakan')
                        ElevatedButton(
                          onPressed: () {
                            _updateOrderStatus(context, orderId, 'terima', statusPekerjaan: 'selesai');
                          },
                          child: const Text(
                            'Selesai',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF9A0000),
                            textStyle: TextStyle(color: Colors.white), // Tambahkan ini untuk memastikan
                          ),
                        ),
                      if (orderDetails['statusPekerjaan'] == 'sedang dikerjakan')
                        ElevatedButton(
                          onPressed: () {
                            _pickAndUploadImage(context);
                          },
                          child: const Text(
                            'Unggah Bukti Proses',
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
