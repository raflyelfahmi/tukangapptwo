import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  String? _pdfFileName;

  Future<void> _pickPDF() async {
    final result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result != null) {
      setState(() {
        _pdfFileName = result.files.first.name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          ElevatedButton(onPressed: _pickPDF, child: Text('Pick a file')),
          Text(_pdfFileName ?? 'No file selected'),
        ],
      ),
    );
  }
}
