import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Farm Activity Log',
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
      themeMode: ThemeMode.system, // Use system theme mode
      home: const FarmActivityLog(),
    );
  }
}

class FarmActivityLog extends StatefulWidget {
  const FarmActivityLog({super.key});

  @override
  _FarmActivityLogState createState() => _FarmActivityLogState();
}

class _FarmActivityLogState extends State<FarmActivityLog> {
  final List<Map<String, String>> _activities = [];
  final TextEditingController _activityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Farm Activity Log'),
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
          children: [
            TextField(
              controller: _activityController,
              decoration: InputDecoration(
                labelText: 'Enter Activity',
                border: const OutlineInputBorder(),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green, width: 2),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    if (_activityController.text.isNotEmpty) {
                      setState(() {
                        _activities.add({
                          'date': DateTime.now().toString(),
                          'activity': _activityController.text,
                        });
                        _activityController.clear();
                      });
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _activities.length,
                itemBuilder: (context, index) {
                  final activity = _activities[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      title: Text(
                        activity['activity']!,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                      subtitle: Text(
                        activity['date']!,
                        style: TextStyle(
                          fontSize: 16,
                          color: isDarkMode ? Colors.white70 : Colors.black54,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
