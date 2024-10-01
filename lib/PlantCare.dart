import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'SettingsProvider.dart';

class PlantCareTips extends StatelessWidget {
  const PlantCareTips({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final isDarkMode = settingsProvider.isDarkMode;

    // List of plant care tips
    final List<Map<String, String>> plantCareTips = [
      {
        'title': 'Watering',
        'content': '1. Water plants early in the morning or late in the evening.\n'
            '2. Ensure soil is moist but not waterlogged.\n'
            '3. Adjust watering frequency based on plant type and weather conditions.'
      },
      {
        'title': 'Fertilizing',
        'content': '1. Use balanced fertilizers to provide essential nutrients.\n'
            '2. Follow the recommended application rates.\n'
            '3. Fertilize during the growing season for best results.'
      },
      {
        'title': 'Pruning',
        'content': '1. Prune dead or diseased branches regularly.\n'
            '2. Use clean and sharp pruning tools.\n'
            '3. Prune to shape the plant and encourage healthy growth.'
      },
      {
        'title': 'Pest Control',
        'content': '1. Inspect plants regularly for pests.\n'
            '2. Use organic pesticides when necessary.\n'
            '3. Remove affected leaves or plants to prevent the spread of pests.'
      },
      {
        'title': 'Soil Care',
        'content': '1. Use well-draining soil for healthy root growth.\n'
            '2. Add organic matter to improve soil fertility.\n'
            '3. Avoid compacting the soil to ensure proper aeration.'
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Plant Care Tips'),
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
          children: plantCareTips.map((tip) {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ExpansionTile(
                  title: Text(
                    tip['title']!,
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
                        tip['content']!,
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
