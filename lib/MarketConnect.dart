import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MarketConnectScreen extends StatefulWidget {
  const MarketConnectScreen({super.key});

  @override
  _MarketConnectScreenState createState() => _MarketConnectScreenState();
}

class _MarketConnectScreenState extends State<MarketConnectScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _marketData = [
    {'name': 'Local Market A', 'price': '₹50/kg', 'contact': '1234567890'},
    {'name': 'Local Market B', 'price': '₹45/kg', 'contact': '9876543210'},
    {'name': 'Organic Market C', 'price': '₹60/kg', 'contact': '4567890123'},
    {'name': 'Farmers Market D', 'price': '₹55/kg', 'contact': '3216549870'},
    {'name': 'Export Market E', 'price': '₹75/kg', 'contact': '6543210987'},
    // Add more market data here
  ];

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final filteredMarketData = _marketData.where((market) {
      return market['name'].toLowerCase().contains(_searchController.text.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Market Connect'),
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
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search Markets',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                suffixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: isDarkMode ? Colors.grey[800] : Colors.white,
              ),
              onChanged: (value) => setState(() {}),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: filteredMarketData.length,
                itemBuilder: (context, index) {
                  final market = filteredMarketData[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(
                        market['name'],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                      subtitle: Text(
                        'Price: ${market['price']}',
                        style: TextStyle(
                          color: isDarkMode ? Colors.white70 : Colors.black54,
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.phone),
                        onPressed: () async {
                          await _launchDialer(market['contact']);
                        },
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MarketDetailsScreen(market: market),
                          ),
                        );
                      },
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

  Future<void> _launchDialer(String phoneNumber) async {
    final Uri telUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(telUri)) {
      await launchUrl(telUri);
    } else {
      throw 'Could not launch $telUri';
    }
  }
}

class MarketDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> market;

  const MarketDetailsScreen({super.key, required this.market});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(market['name']),
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Market Name: ${market['name']}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black),
            ),
            const SizedBox(height: 16),
            Text(
              'Price: ${market['price']}',
              style: TextStyle(fontSize: 18, color: isDarkMode ? Colors.white70 : Colors.black54),
            ),
            const SizedBox(height: 16),
            Text(
              'Contact: ${market['contact']}',
              style: TextStyle(fontSize: 16, color: isDarkMode ? Colors.white70 : Colors.black54),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                final Uri telUri = Uri(scheme: 'tel', path: market['contact']);
                if (await canLaunchUrl(telUri)) {
                  await launchUrl(telUri);
                } else {
                  throw 'Could not launch $telUri';
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: isDarkMode ? Colors.grey[800] : Colors.green),
              child: const Text('Contact Market'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    theme: ThemeData.light(),
    darkTheme: ThemeData.dark(),
    themeMode: ThemeMode.system,
    home: const MarketConnectScreen(),
  ));
}
