import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import './location_helper.dart';
import './LocationInput.dart';
import 'package:FlutterMap/map.dart';
import 'package:FlutterMap/mapScreen.dart';
import 'package:FlutterMap/osamaMap.dart';

import 'package:google_maps_webservice/directions.dart';
import 'package:google_maps_webservice/distance.dart';
import 'package:google_maps_webservice/geocoding.dart';
import 'package:google_maps_webservice/geolocation.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_maps_webservice/timezone.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  // AIzaSyDZQiTjmUsm8HEJ3qtgiT0nCc3u68Oj0Tw
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: OsamaMap(), // Map(), // MapScreen(), // MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GoogleMapController mapController;
  Position position;

  LatLng _center = LatLng(45.521563, -122.677433);
  // LatLng _center ;
  // Lat: 37.4219983, Long: -122.084
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> markers = Set();

  setMarkers() {
    markers.addAll([
      Marker(
        markerId: MarkerId('value'),
        position: _center,
      )
    ]);
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<Position> getLocation() async {
    return Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  getUserLocation() async {
    position = await getLocation();
    setState(() {
      _center = LatLng(position.latitude, position.longitude);
    });
    setMarkers();
    print('center $_center');
  }

  

  @override
  void initState() {
    super.initState();
      setMarkers();
  }
  //void _addmarker()
// Marker marker = Marker(
//       markerId: markerId,
//       position: LatLng(
//         11.052992, 106.681612,
//       ),);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Maps Sample App'),
        backgroundColor: Colors.green[700],
      ),
      // body: GoogleMap(
      //   mapType: MapType.hybrid,
      //   initialCameraPosition: _kGooglePlex,
      //   onMapCreated: (GoogleMapController controller) {
      //     _controller.complete(controller);
      //   },
      // ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: _goToTheLake,
      //   label: Text('To the lake!'),
      //   icon: Icon(Icons.directions_boat),
      // ),
      body: Column(
        //  crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          // LocationInput(),
          Expanded(
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 14.0,
              ),
              markers: markers,
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: FlatButton(
                onPressed: () {
                  getUserLocation();
                },
                child: Text('Share Your Location'),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}
