import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

import '../controllers/ratingulasan_controller.dart';

class RatingulasanView extends GetView<RatingulasanController> {
  final String orderId;

  const RatingulasanView({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    final TextEditingController reviewController = TextEditingController();
    double rating = 0;

    void submitReview() async {
      if (rating > 0 && reviewController.text.isNotEmpty) {
        final DatabaseReference orderRef = FirebaseDatabase.instance.ref().child('orders').child(orderId);
        await orderRef.update({
          'rating': rating,
          'review': reviewController.text,
        });
        Get.back();
        Get.snackbar('Sukses', 'Rating dan ulasan berhasil dikirim', 
          backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        Get.snackbar('Error', 'Mohon berikan rating dan ulasan',
          backgroundColor: Colors.red, colorText: Colors.white);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Beri Rating dan Ulasan', 
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        centerTitle: true,
        backgroundColor: Color(0xFF9A0000),
        elevation: 0,
      ),
      body: SingleChildScrollView(
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
                  const Text('Beri Rating:', 
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Center(
                    child: RatingBar.builder(
                      initialRating: 0,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (newRating) {
                        rating = newRating;
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('Tulis Ulasan:', 
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  TextField(
                    controller: reviewController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Color(0xFF9A0000)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Color(0xFF9A0000), width: 2),
                      ),
                      hintText: 'Tulis ulasan Anda di sini...',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: submitReview,
                      child: const Text('Kirim', style: TextStyle(color: Colors.white)),
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
}