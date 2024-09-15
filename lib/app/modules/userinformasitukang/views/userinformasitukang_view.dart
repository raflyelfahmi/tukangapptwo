import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:tukangapptwo/app/modules/booknowuser/views/booknowuser_view.dart';
import 'package:url_launcher/url_launcher.dart';

final logger = Logger();

class UserinformasitukangView extends StatefulWidget {
  final String userId;
  @override
  final Key? key;

  const UserinformasitukangView({required this.userId, this.key}) : super(key: key);

  @override
  _UserinformasitukangViewState createState() => _UserinformasitukangViewState();
}

class _UserinformasitukangViewState extends State<UserinformasitukangView> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  bool _isPemesan = false;
  bool _isLoading = true;
  Map<String, dynamic>? _tukangUser;
  int _completedOrdersCount = 0;
  double _overallRating = 0.0;
  List<Map<String, dynamic>> _reviews = [];
  String? _tanggalTersedia;

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
        logger.d('User role: $role');
        if (role == 'pemesan') {
          setState(() {
            _isPemesan = true;
          });
          _fetchTukangUser(widget.userId);
        } else {
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        logger.w('Role snapshot value is null');
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      logger.w('User is null');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _fetchTukangUser(String userId) async {
    DatabaseEvent event = await _database.child('users/$userId').once();
    DataSnapshot snapshot = event.snapshot;
    if (snapshot.value != null) {
      setState(() {
        _tukangUser = Map<String, dynamic>.from(snapshot.value as Map);
        _isLoading = false;
      });
      _fetchCompletedOrdersCount(userId);
      _fetchOverallRating(userId);
      _fetchReviews(userId);
      _fetchTanggalTersedia(userId);
    } else {
      logger.w('User snapshot value is null');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _fetchCompletedOrdersCount(String userId) async {
    DatabaseEvent event = await _database.child('orders').orderByChild('tukangId').equalTo(userId).once();
    DataSnapshot snapshot = event.snapshot;
    if (snapshot.value != null) {
      Map<dynamic, dynamic> orders = snapshot.value as Map<dynamic, dynamic>;
      int count = orders.values.where((order) => order['status'] == 'selesai').length;
      setState(() {
        _completedOrdersCount = count;
      });
    }
  }

  void _fetchOverallRating(String userId) async {
    DatabaseEvent event = await _database.child('orders').orderByChild('tukangId').equalTo(userId).once();
    DataSnapshot snapshot = event.snapshot;
    if (snapshot.value != null) {
      Map<dynamic, dynamic> orders = snapshot.value as Map<dynamic, dynamic>;
      var ratedOrders = orders.values.where((order) => order['rating'] != null);
      if (ratedOrders.isNotEmpty) {
        double totalRating = ratedOrders.map((order) => order['rating'] as num).reduce((a, b) => a + b).toDouble();
        setState(() {
          _overallRating = totalRating / ratedOrders.length;
        });
      }
    }
  }

  void _fetchReviews(String userId) async {
    DatabaseEvent event = await _database.child('orders').orderByChild('tukangId').equalTo(userId).once();
    DataSnapshot snapshot = event.snapshot;
    if (snapshot.value != null) {
      Map<dynamic, dynamic> orders = snapshot.value as Map<dynamic, dynamic>;
      List<Map<String, dynamic>> reviews = [];
      for (var order in orders.values) {
        if (order['rating'] != null && order['review'] != null) {
          String pemesanId = order['pemesanId'];
          DatabaseEvent userEvent = await _database.child('users/$pemesanId/name').once();
          String userName = userEvent.snapshot.value as String? ?? 'Anonim';
          
          reviews.add({
            'rating': order['rating'],
            'review': order['review'],
            'userName': userName,
          });
        }
      }
      setState(() {
        _reviews = reviews;
      });
    }
  }

  void _fetchTanggalTersedia(String userId) async {
    DatabaseEvent event = await _database.child('users/$userId/tanggalTersedia').once();
    DataSnapshot snapshot = event.snapshot;
    if (snapshot.value != null) {
      setState(() {
        _tanggalTersedia = snapshot.value as String;
      });
    }
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    logger.d('Trying to launch URL: $url');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      logger.e('Could not launch URL: $url');
      throw 'Could not launch $url';
    }
  }

  Widget _buildRatingStars(double rating) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 20,
        );
      }),
    );
  }

  Widget _buildReviewsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            'Ulasan',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        if (_reviews.isEmpty)
          Text('Belum ada ulasan'),
        ..._reviews.map((review) => _buildReviewItem(review)).toList(),
      ],
    );
  }

  Widget _buildReviewItem(Map<String, dynamic> review) {
    return Card(
      margin: EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  review['userName'],
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                _buildRatingStars(review['rating'].toDouble()),
              ],
            ),
            SizedBox(height: 8),
            Text(review['review']),
            SizedBox(height: 8),
           
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (!_isPemesan) {
      return const Scaffold(
        body: Center(child: Text('Akses ditolak')),
      );
    }

    if (_tukangUser == null) {
      return const Scaffold(
        body: Center(child: Text('User tidak ditemukan')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Informasi Tukang'),
        centerTitle: true,
        backgroundColor: const Color(0xFF9A0000),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: const Color(0xFF9A0000),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Center(
                child: _tukangUser!['profileImageUrl'] != null
                    ? CircleAvatar(
                        radius: 70,
                        backgroundImage: NetworkImage(_tukangUser!['profileImageUrl']),
                      )
                    : const CircleAvatar(
                        radius: 70,
                        child: Icon(Icons.person, size: 70),
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoTile('Nama', _tukangUser!['name']),
                  _buildInfoTile('Email', _tukangUser!['email']),
                  if (_tanggalTersedia != null)
                    _buildInfoTile('Tanggal Ketersediaan', _tanggalTersedia!),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      _buildRatingStars(_overallRating),
                      SizedBox(width: 10),
                      Text('${_overallRating.toStringAsFixed(1)}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green),
                      SizedBox(width: 10),
                      Text('$_completedOrdersCount Terpesan', style: TextStyle(fontSize: 18)),
                    ],
                  ),
                  if (_tukangUser!['pdfUrl'] != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ElevatedButton.icon(
                        onPressed: () => _launchURL(_tukangUser!['pdfUrl']),
                        icon: const Icon(Icons.picture_as_pdf),
                        label: const Text('Lihat PDF'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blue,
                        ),
                      ),
                    ),
                  if (_tukangUser!['pdfUrl'] == null)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        'Tidak ada PDF yang tersedia.',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  SizedBox(height: 20),
                  Divider(thickness: 1),
                  _buildReviewsList(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton.icon(
          onPressed: () {
            Get.to(() => BooknowuserView(tukangUserId: widget.userId));
          },
          icon: const Icon(Icons.book),
          label: const Text('Pesan Sekarang'),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: const Color(0xFF9A0000),
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}