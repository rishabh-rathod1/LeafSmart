// settings_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'SettingsProvider.dart';
import 'about.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Settings'),
            backgroundColor: Colors.green,
            elevation: 0,
          ),
          body: ListView(
            children: [
              const SizedBox(height: 20),
              _buildSection(
                title: 'Preferences',
                children: [
                  _buildSwitchTile(
                    title: 'Dark Mode',
                    subtitle: 'Enable dark theme across the app',
                    value: settings.isDarkMode,
                    onChanged: (value) {
                      settings.setDarkMode(value);
                    },
                  ),
                ],
              ),
              _buildSection(
                title: 'App Information',
                children: [
                  ListTile(
                    leading: const Icon(Icons.info_outline, color: Colors.green),
                    title: const Text('About LeafSmart'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AboutScreen()),
                      );
                    },
                  ),
                  const ListTile(
                    leading: Icon(Icons.update, color: Colors.green),
                    title: Text('Version'),
                    subtitle: Text('1.0.0'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSection({required String title, required List<Widget> children}) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
      activeColor: Colors.green,
    );
  }
}
