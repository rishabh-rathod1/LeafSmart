import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'SettingsProvider.dart';

class TreatmentRecommendations extends StatefulWidget {
  const TreatmentRecommendations({super.key});

  @override
  _TreatmentRecommendationsState createState() => _TreatmentRecommendationsState();
}

class _TreatmentRecommendationsState extends State<TreatmentRecommendations> {
  final List<Map<String, dynamic>> _diseases = [
    {
      'name': 'Powdery Mildew',
      'treatment': '1. Use fungicides such as sulfur or potassium bicarbonate.\n'
          '2. Improve air circulation around plants.\n'
          '3. Avoid overhead watering.'
    },
    {
      'name': 'Blight',
      'treatment': '1. Remove and destroy affected plant parts.\n'
          '2. Apply copper-based fungicides.\n'
          '3. Practice crop rotation.'
    },
    {
      'name': 'Rust',
      'treatment': '1. Apply fungicides like triazole.\n'
          '2. Remove and dispose of infected leaves.\n'
          '3. Choose resistant crop varieties.'
    },
    {
      'name': 'Downy Mildew',
      'treatment': '1. Use appropriate fungicides.\n'
          '2. Ensure proper spacing between plants for air circulation.\n'
          '3. Avoid high humidity environments.'
    },
    {
      'name': 'Fusarium Wilt',
      'treatment': '1. Use resistant varieties of crops.\n'
          '2. Improve soil drainage.\n'
          '3. Apply soil fumigants if necessary.'
    },
    {
      'name': 'Bacterial Spot',
      'treatment': '1. Remove and destroy infected plant parts.\n'
          '2. Use copper-based bactericides.\n'
          '3. Practice good sanitation and avoid overhead irrigation.'
    },
    {
      'name': 'Viral Diseases',
      'treatment': '1. Use virus-resistant plant varieties.\n'
          '2. Control insect vectors.\n'
          '3. Remove and destroy infected plants.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final isDarkMode = settingsProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Treatment Recommendations'),
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.green,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        color: isDarkMode ? Colors.grey[800] : Colors.green.withOpacity(0.1),
        child: ListView(
          children: _diseases.map((disease) {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ExpansionTile(
                  title: Text(
                    disease['name'],
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        disease['treatment'],
                        style: TextStyle(
                          fontSize: 16,
                          color: isDarkMode ? Colors.white70 : Colors.black54,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
