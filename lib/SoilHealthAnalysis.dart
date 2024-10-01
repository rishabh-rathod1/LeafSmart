import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SoilHealthAnalysis extends StatefulWidget {
  const SoilHealthAnalysis({super.key});

  @override
  _SoilHealthAnalysisState createState() => _SoilHealthAnalysisState();
}

class _SoilHealthAnalysisState extends State<SoilHealthAnalysis> {
  BluetoothDevice? _connectedDevice;
  String _soilQuality = 'Not connected';
  bool _isScanning = false;
  List<BluetoothDevice> _devices = [];

  @override
  void initState() {
    super.initState();
    _loadConnectionState();
    _setupBluetoothListeners();
  }

  void _setupBluetoothListeners() {
    FlutterBluePlus.scanResults.listen((results) {
      setState(() {
        _devices = results.map((result) => result.device).toList();
        // Remove duplicates
        _devices = _devices.toSet().toList();
      });
    });

    FlutterBluePlus.isScanning.listen((isScanning) {
      setState(() {
        _isScanning = isScanning;
      });
    });
  }

  Future<void> _startScan() async {
    setState(() {
      _devices.clear();
    });

    try {
      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 4));
    } catch (e) {
      print('Error starting scan: $e');
    }
  }

  Future<void> _connectToDevice(BluetoothDevice device) async {
    try {
      await device.connect();
      setState(() {
        _connectedDevice = device;
      });

      // Save connection state
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('connected_device_id', device.remoteId.toString());

      _discoverServices(device);
    } catch (e) {
      print('Connection failed: $e');
      setState(() {
        _soilQuality = 'Connection failed';
      });
    }
  }

  Future<void> _discoverServices(BluetoothDevice device) async {
    List<BluetoothService> services = await device.discoverServices();
    for (var service in services) {
      for (var characteristic in service.characteristics) {
        if (characteristic.properties.notify) {
          await characteristic.setNotifyValue(true);
          characteristic.value.listen((value) {
            setState(() {
              _soilQuality = String.fromCharCodes(value);
            });
          });
          break;
        }
      }
    }
  }

  Future<void> _disconnectDevice() async {
    if (_connectedDevice != null) {
      await _connectedDevice!.disconnect();
      setState(() {
        _connectedDevice = null;
        _soilQuality = 'Disconnected';
      });

      // Clear saved connection state
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('connected_device_id');
    }
  }

  Future<void> _loadConnectionState() async {
    final prefs = await SharedPreferences.getInstance();
    final deviceId = prefs.getString('connected_device_id');

    if (deviceId != null) {
      final devices = await FlutterBluePlus.systemDevices;
      final device = devices.firstWhere(
            (d) => d.remoteId.toString() == deviceId,
        orElse: () => null as BluetoothDevice,
      );

      _connectToDevice(device);
        }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDarkMode ? Colors.green[700]! : Colors.green;
    final backgroundColor = isDarkMode ? Colors.grey[900]! : Colors.green[50]!;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Soil Health Analysis'),
        backgroundColor: primaryColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Soil Quality',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _soilQuality,
              style: TextStyle(
                fontSize: 18,
                color: textColor.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _isScanning ? null : _startScan,
              icon: Icon(_isScanning ? Icons.hourglass_top : Icons.search),
              label: Text(_isScanning ? 'Scanning...' : 'Scan for Devices'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _devices.length,
                itemBuilder: (context, index) {
                  final device = _devices[index];
                  return Card(
                    color: isDarkMode ? Colors.grey[800] : Colors.white,
                    child: ListTile(
                      leading: Icon(
                        Icons.bluetooth,
                        color: primaryColor,
                      ),
                      title: Text(
                        device.name.isNotEmpty ? device.name : 'Unknown Device',
                        style: TextStyle(color: textColor),
                      ),
                      subtitle: Text(
                        device.id.toString(),
                        style: TextStyle(color: textColor.withOpacity(0.6)),
                      ),
                      trailing: ElevatedButton(
                        onPressed: _connectedDevice?.id == device.id
                            ? _disconnectDevice
                            : () => _connectToDevice(device),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _connectedDevice?.id == device.id ? Colors.red : primaryColor,
                          foregroundColor: Colors.white,
                        ),
                        child: Text(_connectedDevice?.id == device.id ? 'Disconnect' : 'Connect'),
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