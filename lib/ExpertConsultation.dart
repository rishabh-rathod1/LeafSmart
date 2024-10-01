import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expert Consultation',
      theme: ThemeData(
        primarySwatch: Colors.green,
        brightness: Brightness.light,
        appBarTheme: const AppBarTheme(
          color: Colors.green,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        appBarTheme: AppBarTheme(
          color: Colors.grey[900],
        ),
      ),
      themeMode: ThemeMode.system,
      home: const ExpertConsultation(),
    );
  }
}

class ExpertConsultation extends StatefulWidget {
  const ExpertConsultation({super.key});

  @override
  _ExpertConsultationState createState() => _ExpertConsultationState();
}

class _ExpertConsultationState extends State<ExpertConsultation> {
  final TextEditingController _queryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expert Consultation'),
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.green,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        color: isDarkMode ? Colors.grey[800] : Colors.green.withOpacity(0.1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Contact Information
            Text(
              'Contact Agricultural Experts',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'For expert advice and troubleshooting, you can contact our agricultural experts through the following methods:',
              style: TextStyle(
                fontSize: 16,
                color: isDarkMode ? Colors.white70 : Colors.black54,
              ),
            ),
            const SizedBox(height: 20),
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                title: Text(
                  'Email: experts@agriculture.com',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                trailing: Icon(Icons.email, color: isDarkMode ? Colors.white : Colors.black),
              ),
            ),
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                title: Text(
                  'Phone: +123 456 7890',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                trailing: Icon(Icons.phone, color: isDarkMode ? Colors.white : Colors.black),
              ),
            ),

            const SizedBox(height: 20),

            // Query Submission Form
            Text(
              'Submit Your Query',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _queryController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Enter your query here...',
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle query submission
                final query = _queryController.text;
                if (query.isNotEmpty) {
                  // Simulate sending the query
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Your query has been submitted.')),
                  );
                  _queryController.clear();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isDarkMode ? Colors.grey[800] : Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: Text(
                'Submit Query',
                style: TextStyle(
                  fontSize: 18,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
