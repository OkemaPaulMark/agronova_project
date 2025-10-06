import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';

class DiagnosisPage extends StatefulWidget {
  const DiagnosisPage({super.key});

  @override
  State<DiagnosisPage> createState() => _DiagnosisPageState();
}

class _DiagnosisPageState extends State<DiagnosisPage> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  String _result = "No diagnosis yet.";
  double _confidence = 0.0;
  String _advice = "";

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source, imageQuality: 85);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _result = "No diagnosis yet.";
        _confidence = 0.0;
        _advice = "";
      });
    }
  }

  Future<void> _runDiagnosis() async {
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please upload or capture an image first.")),
      );
      return;
    }

    final uri = Uri.parse("http://10.10.132.157:8000/predict"); // Use 10.0.2.2 for Android Emulator, else localhost
    final request = http.MultipartRequest('POST', uri);
    request.files.add(await http.MultipartFile.fromPath('file', _selectedImage!.path));

    setState(() {
      _result = "Diagnosing...";
      _advice = "";
    });

    try {
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final data = jsonDecode(responseBody);
        setState(() {
          _result = data['class'] ?? "Unknown";
          _confidence = (data['confidence'] ?? 0.0) * 100;
          _advice = data['advice'] ?? "No advice provided.";
        });
      } else {
        setState(() {
          _result = "Failed to get result. Code: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        _result = "Error: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diagnosis', style: TextStyle(color: Colors.white, fontSize: 20)),
        backgroundColor: Colors.green[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Step 1
              const Text('Step 1: Upload or Take a Photo',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _customButton(Icons.image, 'Upload', () => _pickImage(ImageSource.gallery)),
                  _customButton(Icons.camera_alt, 'Camera', () => _pickImage(ImageSource.camera)),
                ],
              ),
              const SizedBox(height: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: _selectedImage != null
                    ? Image.file(_selectedImage!, height: 180, width: double.infinity, fit: BoxFit.cover)
                    : Image.asset('assets/leaf.jpg', height: 180, width: double.infinity, fit: BoxFit.cover),
              ),

              // Step 2
              const SizedBox(height: 20),
              const Text('Step 2: Diagnose',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _runDiagnosis,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('Diagnose', style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),

              // Step 3
              const SizedBox(height: 20),
              const Text('Step 3: Result',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAFBE8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Disease: $_result'),
                    const SizedBox(height: 4),
                    Text('Confidence: ${_confidence.toStringAsFixed(2)}%'),
                    const SizedBox(height: 4),
                    Text('Advice: $_advice'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _customButton(IconData icon, String label, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF0F5F0),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: Colors.green[700]),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
