import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DiseaseDetector extends StatefulWidget {
  const DiseaseDetector({super.key});

  @override
  _DiseaseDetectorState createState() => _DiseaseDetectorState();
}

class _DiseaseDetectorState extends State<DiseaseDetector> {
  XFile? _selectedImage;
  String _cropName = '';
  String _cropHybrid = 'none';
  String _serverMessage = '';

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);

    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  void _showImageSourceOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Image Source'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take Photo'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _detectImage() async {
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No image selected!')),
      );
      return;
    }

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://your-server-ip:5000/detect'),
      );

      request.fields['cropName'] = _cropName;
      request.fields['cropHybrid'] = _cropHybrid;
      request.files.add(await http.MultipartFile.fromPath(
        'image',
        _selectedImage!.path,
      ));

      var response = await request.send();

      if (response.statusCode == 200) {
        var responseBody = await http.Response.fromStream(response);
        var jsonResponse = jsonDecode(responseBody.body);

        setState(() {
          _serverMessage = 'Prediction: ${jsonResponse['prediction']}\nConfidence: ${jsonResponse['confidence']}';
        });
      } else {
        setState(() {
          _serverMessage = 'Server error: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _serverMessage = 'Server down or unreachable';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Disease Detector'),
        backgroundColor: isDarkMode ? Colors.grey[850] : Colors.green,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.3,
              width: double.infinity,
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey[800] : Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: _selectedImage == null
                  ? Center(
                child: Icon(
                  Icons.camera_alt,
                  size: 80,
                  color: isDarkMode ? Colors.grey[600] : Colors.green.withOpacity(0.5),
                ),
              )
                  : ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.file(
                  File(_selectedImage!.path),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Crop Name',
                      border: const OutlineInputBorder(),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green, width: 2),
                      ),
                      filled: true,
                      fillColor: isDarkMode ? Colors.grey[850] : Colors.white,
                      labelStyle: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _cropName = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Crop Hybrid',
                      border: const OutlineInputBorder(),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green, width: 2),
                      ),
                      filled: true,
                      fillColor: isDarkMode ? Colors.grey[850] : Colors.white,
                      labelStyle: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _cropHybrid = value.isEmpty ? 'none' : value;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _showImageSourceOptions(context),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text('Select Image'),
            ),
            if (_selectedImage != null) ...[
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _detectImage,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text('Detect'),
              ),
            ],
            const SizedBox(height: 30),
            if (_serverMessage.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  color: _serverMessage.contains('error')
                      ? (isDarkMode ? Colors.red[900] : Colors.red.shade100)
                      : (isDarkMode ? Colors.green[900] : Colors.green.shade100),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Text(
                      _serverMessage,
                      style: TextStyle(
                        fontSize: 16,
                        color: _serverMessage.contains('error')
                            ? (isDarkMode ? Colors.red.shade200 : Colors.red.shade700)
                            : (isDarkMode ? Colors.green.shade200 : Colors.green.shade700),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
