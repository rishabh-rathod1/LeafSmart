import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController _locationController = TextEditingController();
  String _location = '';
  Map<String, dynamic>? _weatherData;
  String _errorMessage = '';
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchWeatherData();
  }

  Future<void> _fetchWeatherData({String? location}) async {
    setState(() {
      _errorMessage = '';
      _loading = true;
    });

    const apiKey = 'c46df2a15d21585e86aa146c09039711';

    try {
      String url;

      if (location == null || location.isEmpty) {
        // Request location permission
        final status = await Permission.location.request();

        if (status.isDenied) {
          setState(() {
            _errorMessage = 'Location permission denied';
            _loading = false;
          });
          return;
        }

        // Fetch current location
        final Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        url = 'https://api.openweathermap.org/data/2.5/forecast?lat=${position.latitude}&lon=${position.longitude}&units=metric&appid=$apiKey';
      } else {
        url = 'https://api.openweathermap.org/data/2.5/forecast?q=$location&units=metric&appid=$apiKey';
      }

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          _weatherData = jsonDecode(response.body);
          _location = _weatherData!['city']['name'];
          _loading = false;
        });
      } else {
        final errorBody = jsonDecode(response.body);
        setState(() {
          _errorMessage = 'Failed to load weather data: ${errorBody['message'] ?? response.reasonPhrase}';
          _loading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Forecast'),
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.green,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey[800] : Colors.green.withOpacity(0.1),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _locationController,
                    decoration: InputDecoration(
                      labelText: 'Enter location',
                      border: const OutlineInputBorder(),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green, width: 2),
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          _fetchWeatherData(location: _locationController.text);
                        },
                      ),
                    ),
                    onSubmitted: (value) {
                      _fetchWeatherData(location: value);
                    },
                  ),
                  const SizedBox(height: 20),
                  if (_loading) const Center(child: CircularProgressIndicator()),
                  if (_weatherData != null && !_loading) ...[
                    Text(
                      _location,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black),
                    ),
                    const SizedBox(height: 20),
                    ..._weatherData!['list'].take(5).map<Widget>((weather) {
                      final DateTime date = DateTime.fromMillisecondsSinceEpoch(weather['dt'] * 1000);
                      final String dateStr = DateFormat('E, MMM d').format(date);
                      final String timeStr = DateFormat('HH:mm').format(date);
                      final String weatherDesc = weather['weather'][0]['description'];
                      final double temp = weather['main']['temp'];

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          title: Text('$dateStr at $timeStr', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black)),
                          subtitle: Text(weatherDesc, style: TextStyle(fontSize: 16, color: isDarkMode ? Colors.white70 : Colors.black54)),
                          trailing: Text('${temp.toStringAsFixed(1)}°C', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black)),
                        ),
                      );
                    }).toList(),
                  ] else if (_errorMessage.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Card(
                        color: Colors.red.shade100,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Text(
                            _errorMessage,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.red.shade700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}