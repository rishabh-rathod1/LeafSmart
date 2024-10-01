import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Import Flutter SVG package

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About LeafSmart'),
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display the app image (SVG)
            SvgPicture.asset(
              'assets/leaf.svg', // Path to the app logo
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 20),
            // App description
            const Text(
              'LeafSmart is an innovative app designed to help farmers manage their crops efficiently. From detecting crop diseases to providing treatment recommendations, our app aims to enhance productivity and sustainability in farming.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            // Version information
            const Text(
              'Version: 1.0.0',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
