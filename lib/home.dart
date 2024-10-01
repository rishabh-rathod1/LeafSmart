import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import provider package
import 'DiseaseDetector.dart';
import 'WeedIdentifier.dart';
import 'Weather.dart';
import 'soon.dart';
import 'SettingsProvider.dart'; // Ensure this import path is correct
import 'Settings.dart';
import 'TreatmentRecommendations.dart';
import 'PlantCare.dart';
import 'FertilizerCalculator.dart';
import 'FertilizerMarket.dart';
import 'MarketConnect.dart';
import 'SoilHealthAnalysis.dart';
import 'FarmActivityLog.dart';
import 'FinancialManagement.dart';
import 'ExpertConsultation.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0.0;

  final List<FeatureItem> features = [
    FeatureItem(icon: Icons.bug_report, title: 'Disease Detection'),
    FeatureItem(icon: Icons.grass, title: 'Weed Identification'),
    FeatureItem(icon: Icons.healing, title: 'Treatment Recommendations'),
    FeatureItem(icon: Icons.support_agent, title: 'Expert Consultation'),
    FeatureItem(icon: Icons.calculate, title: 'Fertilizer Calculator'),
    FeatureItem(icon: Icons.eco, title: 'Plant Care Tips'),
    FeatureItem(icon: Icons.shopping_cart, title: 'Buying Fertilizers'),
    FeatureItem(icon: Icons.store, title: 'Market Connect'),
    FeatureItem(icon: Icons.landscape, title: 'Soil Health Analysis'),
    FeatureItem(icon: Icons.water_drop, title: 'Water Management Tips'),
    FeatureItem(icon: Icons.cloud, title: 'Weather Forecast'),
    FeatureItem(icon: Icons.pest_control, title: 'Pest Identification and Control'),
    FeatureItem(icon: Icons.event_note, title: 'Farm Activity Log'),
    FeatureItem(icon: Icons.trending_up, title: 'Yield Prediction'),
    FeatureItem(icon: Icons.pets, title: 'Livestock Health Monitoring'),
    FeatureItem(icon: Icons.water, title: 'Smart Irrigation Integration'),
    FeatureItem(icon: Icons.forum, title: 'Community Forum'),
    FeatureItem(icon: Icons.account_balance_wallet, title: 'Financial Management'),
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    setState(() {
      _scrollOffset = _scrollController.offset;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, child) {
        return Scaffold(
          body: CustomScrollView(
            controller: _scrollController,
            slivers: <Widget>[
              SliverAppBar(
                expandedHeight: 150.0,
                floating: false,
                pinned: true,
                flexibleSpace: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    var top = constraints.biggest.height;
                    return FlexibleSpaceBar(
                      titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
                      title: const Text(
                        'LeafSmart',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      background: Stack(
                        fit: StackFit.expand,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
                            child: Image.asset(
                              'assets/bg.jpeg',
                              fit: BoxFit.cover,
                            ),
                          ),
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(_getOpacity()),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                backgroundColor: Colors.green,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
                ),
                actions: [
                  Builder(
                    builder: (context) => IconButton(
                      icon: const Icon(Icons.menu, color: Colors.white),
                      onPressed: () {
                        Scaffold.of(context).openEndDrawer();
                      },
                    ),
                  ),
                ],
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.2,
                  ),
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      return FeatureCard(feature: features[index]);
                    },
                    childCount: features.length,
                  ),
                ),
              ),
            ],
          ),
          endDrawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                const DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.green,
                  ),
                  child: Text(
                    'LeafSmart Menu',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Settings'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Profile'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const ComingSoonScreen(title: 'Profile',)));
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  double _getOpacity() {
    const double startOffset = 0;
    const double endOffset = 100;

    if (_scrollOffset <= startOffset) return 0.0;
    if (_scrollOffset >= endOffset) return 1.0;

    return (_scrollOffset - startOffset) / (endOffset - startOffset);
  }
}

class FeatureCard extends StatelessWidget {
  final FeatureItem feature;

  const FeatureCard({super.key, required this.feature});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          if (feature.title == 'Disease Detection') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const DiseaseDetector()),
            );
          } else if (feature.title == 'Weed Identification') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const WeedIdentifier()),
            );
          } else if (feature.title == 'Weather Forecast') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const WeatherScreen()),
            );
          }
          else if(feature.title=='Treatment Recommendations'){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const TreatmentRecommendations()),
            );
          }
          else if(feature.title=='Plant Care Tips'){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PlantCareTips()),
            );
          }
          else if(feature.title=='Fertilizer Calculator'){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FertilizerQuantityCalculator()),
            );
          }
          else if(feature.title=='Buying Fertilizers'){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FertilizerStoreScreen()),
            );
          }
          else if(feature.title=='Market Connect'){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MarketConnectScreen()),
            );
          }
          else if(feature.title=='Expert Consultation'){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) =>  const ExpertConsultation()),
            );
          }
          else if(feature.title=='Soil Health Analysis'){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SoilHealthAnalysis()),
            );
          }
          else if(feature.title=='Financial Management'){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) =>  const FinancialManagement()),
            );
          }
          else if(feature.title=='Farm Activity Log'){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FarmActivityLog()),
            );
          }
          else {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const ComingSoonScreen(title: 'Coming Soon',)));
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(feature.icon, size: 40, color: Colors.green),
              const SizedBox(height: 8),
              Text(
                feature.title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FeatureItem {
  final IconData icon;
  final String title;

  FeatureItem({required this.icon, required this.title});
}
