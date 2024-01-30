import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'GPS Spike'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Position? _position;
  String? _location;
  bool? _isRecording;

  void _getCurrentLocation() async {
    Position position = await _determinePosition();

    setState(() {
      _position = position;
    });
  } //_getCurrentLocation()

  void _startRecording() {
    print(_isRecording);

    setState(() {
      _getCurrentLocation();
      _isRecording = true;
    });
  }

  void _stopRecording() {
    print(_isRecording);

    setState(() {
      _getCurrentLocation();
      _isRecording = false;
    });
  }

  Future<Position> _determinePosition() async {
    LocationPermission permission;

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error("Location permission denied");
      }
    }

    return (Geolocator.getCurrentPosition());
  } // _determinePosition()

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("flutter gps spike"),
      ),
      body: Column(
        children: [
          _isRecording == true ? Text("Recording") : Text("Not Recording"),
          Center(
              child: _position != null
                  ? Text(_position.toString())
                  : Text("No location yet")),
        ],
      ),
      floatingActionButton: _isRecording == false
          ? FloatingActionButton(
              onPressed: _startRecording,
              tooltip: 'Start Recording',
              child: const Icon(Icons.fiber_manual_record, color: Colors.red))
          : FloatingActionButton(
              backgroundColor: Colors.red[400],
              onPressed: _stopRecording,
              tooltip: 'Stop Recording',
              child: const Icon(
                Icons.stop,
                color: Colors.black,
              ),
            ),
    );
  } // build
} // class _MyHomePageState
