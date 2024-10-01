import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'SettingsProvider.dart';

class FertilizerQuantityCalculator extends StatefulWidget {
  const FertilizerQuantityCalculator({super.key});

  @override
  _FertilizerQuantityCalculatorState createState() => _FertilizerQuantityCalculatorState();
}

class _FertilizerQuantityCalculatorState extends State<FertilizerQuantityCalculator> {
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _fertilizerRateController = TextEditingController();
  String _result = '';

  void _calculateFertilizer() {
    final area = double.tryParse(_areaController.text) ?? 0;
    final fertilizerRate = double.tryParse(_fertilizerRateController.text) ?? 0;

    if (area <= 0 || fertilizerRate <= 0) {
      setState(() {
        _result = 'Please enter valid numbers for area and fertilizer rate.';
      });
      return;
    }

    final totalFertilizer = area * fertilizerRate;
    setState(() {
      _result = 'Total fertilizer required: ${totalFertilizer.toStringAsFixed(2)} kg';
    });
  }

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final isDarkMode = settingsProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fertilizer Quantity Calculator'),
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
              controller: _areaController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Area of Land (in acres)',
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _fertilizerRateController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Fertilizer Rate (kg/acre)',
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calculateFertilizer,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text('Calculate'),
            ),
            const SizedBox(height: 20),
            if (_result.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.grey[700] : Colors.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  _result,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
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
