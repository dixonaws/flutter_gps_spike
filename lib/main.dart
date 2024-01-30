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
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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

  void _getCurrentLocation() async {
    Position position = await _determinePosition();

    setState(() {
      _position = position;
    });

  } //_getCurrentLocation()

  Future<Position> _determinePosition() async {
    LocationPermission permission;

    permission=await Geolocator.checkPermission();

    if(permission==LocationPermission.denied) {
      permission=await Geolocator.requestPermission();

      if(permission==LocationPermission.denied) {
        return Future.error("Location permission denied");
      }

    }

    return(Geolocator.getCurrentPosition());
  } // _determinePosition()


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("flutter gps spike"),
      ),
      body: Center(
          child: _position != null
              ? Text(_position.toString())
              : Text("No location yet")),
      floatingActionButton: FloatingActionButton(
        onPressed: _getCurrentLocation,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  } // build

} // class _MyHomePageState
