import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TuEdittimView extends StatefulWidget {
  const TuEdittimView({Key? key}) : super(key: key);

  @override
  _TuEdittimViewState createState() => _TuEdittimViewState();
}

class _TuEdittimViewState extends State<TuEdittimView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _teamCountController = TextEditingController();
  bool _isIndividual = false;
  bool _isTeam = false;
  bool _isLoading = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.reference();

  @override
  void initState() {
    super.initState();
    // Load initial data from the controller or database
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      final DatabaseReference userRef = _database.child('users/${user.uid}');
      final DataSnapshot snapshot = await userRef.get();

      if (snapshot.exists) {
        final userData = snapshot.value as Map<dynamic, dynamic>;
        setState(() {
          _isIndividual = userData['isIndividual'] ?? false;
          _isTeam = userData['isTeam'] ?? false;
          _teamCountController.text = userData['teamCount']?.toString() ?? '';
        });
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _updateTeamInfo() async {
    if (_formKey.currentState!.validate()) {
      User? user = _auth.currentUser;
      if (user != null) {
        final DatabaseReference userRef = _database.child('users/${user.uid}');
        Map<String, dynamic> updates = {
          'isIndividual': _isIndividual,
          'isTeam': _isTeam,
        };

        if (_isTeam) {
          updates['teamCount'] = int.tryParse(_teamCountController.text);
        } else {
          updates['teamCount'] = null;
        }

        await userRef.update(updates);
        Get.snackbar('Success', 'Team information updated successfully');
      }
    }
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Color(0xFF6E6E6E)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: Color(0xFF6E6E6E)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: Color(0xFF6E6E6E), width: 2.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: Color(0xFF6E6E6E)),
      ),
    );
  }

  ButtonStyle _buttonStyle() {
    return ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: Color(0xFF9A0000), // Warna teks tombol
      padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      textStyle: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Tim Tukang'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CheckboxListTile(
                    title: const Text('Mendaftar sebagai Individu'),
                    value: _isIndividual,
                    onChanged: (bool? value) {
                      setState(() {
                        _isIndividual = value ?? false;
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: const Text('Mendaftar sebagai Tim'),
                    value: _isTeam,
                    onChanged: (bool? value) {
                      setState(() {
                        _isTeam = value ?? false;
                      });
                    },
                  ),
                  if (_isTeam)
                    TextFormField(
                      controller: _teamCountController,
                      decoration: _inputDecoration('Jumlah Tim'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (_isTeam && (value == null || value.isEmpty)) {
                          return 'Please enter the number of team members';
                        }
                        return null;
                      },
                    ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _updateTeamInfo,
                    style: _buttonStyle(),
                    child: const Text('Perbarui'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _teamCountController.dispose();
    super.dispose();
  }
}
