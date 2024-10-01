import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart'; // Import provider package
import 'SettingsProvider.dart'; // Import the SettingsProvider

class WeedIdentifier extends StatefulWidget {
  const WeedIdentifier({super.key});

  @override
  _WeedIdentifierState createState() => _WeedIdentifierState();
}

class _WeedIdentifierState extends State<WeedIdentifier> {
  XFile? _selectedImage;
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
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
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

  Future<void> _identifyWeed() async {
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No image selected!')),
      );
      return;
    }

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://your-server-ip:5000/identify-weed'),
      );

      request.files.add(await http.MultipartFile.fromPath(
        'image',
        _selectedImage!.path,
      ));

      var response = await request.send();

      if (response.statusCode == 200) {
        var responseBody = await http.Response.fromStream(response);
        var jsonResponse = jsonDecode(responseBody.body);

        setState(() {
          _serverMessage = 'Weed Identified: ${jsonResponse['weedName']}';
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
    // Retrieve the current settings from the provider
    final settings = Provider.of<SettingsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weed Identifier'),
        backgroundColor: settings.isDarkMode ? Colors.grey[900] : Colors.green,
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
                color: settings.isDarkMode ? Colors.grey[800] : Colors.green.withOpacity(0.1),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
              ),
              child: _selectedImage == null
                  ? Center(
                child: Icon(
                  Icons.camera_alt,
                  size: 80,
                  color: settings.isDarkMode ? Colors.white.withOpacity(0.5) : Colors.green.withOpacity(0.5),
                ),
              )
                  : ClipRRect(
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
                child: Image.file(
                  File(_selectedImage!.path),
                  fit: BoxFit.cover,
                ),
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
                onPressed: _identifyWeed,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text('Identify'),
              ),
            ],
            const SizedBox(height: 30),
            if (_serverMessage.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  color: _serverMessage.contains('error')
                      ? Colors.red.shade100
                      : Colors.green.shade100,
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
                            ? Colors.red.shade700
                            : Colors.green.shade700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
      backgroundColor: settings.isDarkMode ? Colors.black : Colors.white,
    );
  }
}
