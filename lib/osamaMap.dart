import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_webservice/places.dart';

class OsamaMap extends StatefulWidget {
  @override
  _OsamaMapState createState() => _OsamaMapState();
}

class _OsamaMapState extends State<OsamaMap> {
  GoogleMapController _controller;
  PageController _pageController;
  Position position;
  int prevPage;
  Set<Marker> markers = Set();
  List<Marker> allMarkers = [];
  final places = new GoogleMapsPlaces(apiKey: "<API_KEY>");

  getUserLocation() async {
    position = await getLocation();
    print('######### your position is $position');
    setState(() {
      markers.clear();
      markers.add(Marker(
        // draggable: false,
        infoWindow: InfoWindow(title: 'Osma'),
        markerId: MarkerId('osama'),
        position: LatLng(position.latitude, position.longitude),
      //  draggable: true,
      //  onDragEnd: (dragEndPosition){},
      ));
    });
    moveCamera();
  }

  Future<Position> getLocation() async {
    return Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  moveCamera() {
    print('########## move Camera');
    _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(
            position.latitude,
            position
                .longitude), // coffeeShops[_pageController.page.toInt()].locationCoords,
        zoom: 14.0,
        bearing: 45.0,
        tilt: 45.0)));
  }

  setUpMarker() {
    markers.add(Marker(
      markerId: MarkerId('value'),
      position: LatLng(40.7128, -74.0060),
    ));
  }

  @override
  void initState() {
    super.initState();
    setUpMarker();
    // allMarkers.add(Marker(
    //     markerId: MarkerId('myMarker'),
    //     draggable: false,
    //     onTap: () {
    //       print('Marker Tapped');
    //     },
    //     position: LatLng(40.7128, -74.0060)));
    _pageController = PageController(initialPage: 1, viewportFraction: 0.8);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Osama Map')),
      body: Stack(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 50.0,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(40.7128, -74.0060),
                zoom: 15,
              ),
              markers: markers,
              //  markers: Set.from(allMarkers),
              onMapCreated: mapCreated,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: FlatButton(
              onPressed: () {
                print('###############');
                getUserLocation();
              },
              child: Text('Share Your Location'),
            ),
          ),
        ],
      ),
    );
  }

  void mapCreated(controller) {
    setState(() {
      _controller = controller;
    });
  }
}
